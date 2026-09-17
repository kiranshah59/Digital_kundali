import 'package:flutter_bloc/flutter_bloc.dart';
import 'naming_state.dart';
import '../data/naming_service.dart';
import '../data/models.dart';

class NamingCubit extends Cubit<NamingState> {
  NamingCubit() : super(NamingInitial());

  Future<void> loadInitialSuggestions(String profileId) async {
    emit(const NamingLoading(isFirstLoad: true));
    
    final result = await NamingService.getNamingSuggestionsForProfile(profileId);
    
    if (result['success']) {
      final response = NamingSuggestionResponse.fromJson(result['data']);
      emit(NamingLoaded(
        startingSound: response.startingSound,
        names: response.names,
        pagination: response.pagination,
      ));
    } else {
      if (result['statusCode'] == 402) {
        emit(NamingPaymentRequired(message: result['message']));
      } else {
        emit(NamingError(message: result['message'], statusCode: result['statusCode']));
      }
    }
  }

  Future<void> loadMore() async {
    if (state is! NamingLoaded) return;
    final currentState = state as NamingLoaded;
    
    if (!currentState.pagination.hasMore) return;
    if (currentState.isGeneratingMore) return;

    emit(currentState.copyWith(isGeneratingMore: true));
    
    final nextPage = currentState.pagination.currentPage + 1;
    
    final result = await NamingService.getMoreNamingSuggestions(
      startingSound: currentState.startingSound,
      gender: currentState.genderFilter,
      origin: currentState.originFilter,
      page: nextPage,
    );
    
    if (result['success']) {
      final response = NamingSuggestionResponse.fromJson(result['data']);
      emit(currentState.copyWith(
        names: [...currentState.names, ...response.names],
        pagination: response.pagination,
        isGeneratingMore: false,
      ));
    } else {
      // Just stop loading more on error
      emit(currentState.copyWith(isGeneratingMore: false));
    }
  }

  Future<void> applyFilter({String? gender, String? origin}) async {
    if (state is! NamingLoaded) return;
    final currentState = state as NamingLoaded;

    // Show loading while maintaining filter state visually if needed, 
    // but simplest is to just emit loading and fetch again.
    final startingSound = currentState.startingSound;
    
    emit(const NamingLoading(isFirstLoad: false));
    
    final result = await NamingService.getMoreNamingSuggestions(
      startingSound: startingSound,
      gender: gender,
      origin: origin,
      page: 1, // Reset to page 1 on filter change
    );
    
    if (result['success']) {
      final response = NamingSuggestionResponse.fromJson(result['data']);
      emit(currentState.copyWith(
        startingSound: startingSound,
        names: response.names,
        pagination: response.pagination,
        genderFilter: gender,
        originFilter: origin,
        clearGenderFilter: gender == null,
        clearOriginFilter: origin == null,
      ));
    } else {
      emit(NamingError(message: result['message'], statusCode: result['statusCode']));
    }
  }

  Future<void> generateMoreNames() async {
    if (state is! NamingLoaded) return;
    final currentState = state as NamingLoaded;
    
    if (currentState.isGeneratingMore) return;
    
    emit(currentState.copyWith(isGeneratingMore: true));
    
    final result = await NamingService.generateMoreNamingSuggestions(
      startingSound: currentState.startingSound,
      gender: currentState.genderFilter,
      origin: currentState.originFilter,
    );
    
    if (result['success']) {
      // API returns refreshed names and pagination
      final response = NamingSuggestionResponse.fromJson(result['data']);
      
      // The API might return just the newly added ones, or the whole refreshed page 1.
      // Assuming it returns the refreshed list (page 1) based on the docs: 
      // "Returns added_count + refreshed names / pagination"
      emit(currentState.copyWith(
        names: response.names,
        pagination: response.pagination,
        isGeneratingMore: false,
      ));
    } else {
      emit(currentState.copyWith(isGeneratingMore: false));
    }
  }

  Future<void> toggleReaction(String babyNameId, String reactionType) async {
    if (state is! NamingLoaded) return;
    final currentState = state as NamingLoaded;
    
    // Optimistic update
    final nameIndex = currentState.names.indexWhere((n) => n.id == babyNameId);
    if (nameIndex == -1) return;
    
    final babyName = currentState.names[nameIndex];
    
    String? newReaction;
    int newLikesCount = babyName.likesCount;
    int newDislikesCount = babyName.dislikesCount;
    
    if (babyName.reaction == reactionType) {
      // Removing reaction
      newReaction = null;
      if (reactionType == 'like') newLikesCount--;
      if (reactionType == 'dislike') newDislikesCount--;
      
      _optimisticUpdate(currentState, nameIndex, babyName, newReaction, newLikesCount, newDislikesCount);
      await NamingService.deleteReaction(babyNameId);
    } else {
      // Changing or adding reaction
      newReaction = reactionType;
      
      // Remove old reaction counts if any
      if (babyName.reaction == 'like') newLikesCount--;
      if (babyName.reaction == 'dislike') newDislikesCount--;
      
      // Add new reaction count
      if (reactionType == 'like') newLikesCount++;
      if (reactionType == 'dislike') newDislikesCount++;
      
      _optimisticUpdate(currentState, nameIndex, babyName, newReaction, newLikesCount, newDislikesCount);
      await NamingService.postReaction(babyNameId, reactionType);
    }
  }

  void _optimisticUpdate(NamingLoaded currentState, int nameIndex, BabyName babyName, String? newReaction, int newLikes, int newDislikes) {
    final updatedName = BabyName(
      id: babyName.id,
      name: babyName.name,
      nameDevanagari: babyName.nameDevanagari,
      gender: babyName.gender,
      origin: babyName.origin,
      meaning: babyName.meaning,
      source: babyName.source,
      reaction: newReaction,
      likesCount: newLikes,
      dislikesCount: newDislikes,
    );
    
    final updatedNames = List<BabyName>.from(currentState.names);
    updatedNames[nameIndex] = updatedName;
    
    emit(currentState.copyWith(names: updatedNames));
  }
}
