import 'package:equatable/equatable.dart';
import '../data/models.dart';

abstract class NamingState extends Equatable {
  const NamingState();

  @override
  List<Object?> get props => [];
}

class NamingInitial extends NamingState {}

class NamingLoading extends NamingState {
  final bool isFirstLoad;
  const NamingLoading({this.isFirstLoad = true});
  
  @override
  List<Object?> get props => [isFirstLoad];
}

class NamingLoaded extends NamingState {
  final String startingSound;
  final List<BabyName> names;
  final PaginationInfo pagination;
  final String? genderFilter;
  final String? originFilter;
  final bool isGeneratingMore;

  const NamingLoaded({
    required this.startingSound,
    required this.names,
    required this.pagination,
    this.genderFilter,
    this.originFilter,
    this.isGeneratingMore = false,
  });

  NamingLoaded copyWith({
    String? startingSound,
    List<BabyName>? names,
    PaginationInfo? pagination,
    String? genderFilter,
    bool clearGenderFilter = false,
    String? originFilter,
    bool clearOriginFilter = false,
    bool? isGeneratingMore,
  }) {
    return NamingLoaded(
      startingSound: startingSound ?? this.startingSound,
      names: names ?? this.names,
      pagination: pagination ?? this.pagination,
      genderFilter: clearGenderFilter ? null : (genderFilter ?? this.genderFilter),
      originFilter: clearOriginFilter ? null : (originFilter ?? this.originFilter),
      isGeneratingMore: isGeneratingMore ?? this.isGeneratingMore,
    );
  }

  @override
  List<Object?> get props => [
        startingSound,
        names,
        pagination,
        genderFilter,
        originFilter,
        isGeneratingMore,
      ];
}

class NamingError extends NamingState {
  final String message;
  final int? statusCode;

  const NamingError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NamingPaymentRequired extends NamingState {
  final String message;
  const NamingPaymentRequired({this.message = 'Payment Required'});
  
  @override
  List<Object?> get props => [message];
}
