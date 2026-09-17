import 'package:flutter_bloc/flutter_bloc.dart';
import 'guru_chat_event.dart';
import 'guru_chat_state.dart';
import '../data/guru_service.dart';
import '../models/guru_message_model.dart';
import '../models/guru_quota_model.dart';

class GuruChatBloc extends Bloc<GuruChatEvent, GuruChatState> {
  GuruChatBloc() : super(GuruChatInitial()) {
    on<LoadGuruChat>(_onLoadGuruChat);
    on<SendGuruMessage>(_onSendGuruMessage);
    on<CheckGuruQuota>(_onCheckGuruQuota);
  }

  List<GuruMessageModel> _currentMessages = [];
  GuruQuotaModel? _currentQuota;

  Future<void> _onLoadGuruChat(
    LoadGuruChat event,
    Emitter<GuruChatState> emit,
  ) async {
    emit(GuruChatLoading(messages: _currentMessages, quota: _currentQuota));

    // Fetch quota and history in parallel
    final results = await Future.wait([
      GuruService.getGuruChatQuota(),
      GuruService.getGuruChatHistory(event.profileId),
    ]);

    final quotaRes = results[0];
    final historyRes = results[1];

    if (quotaRes['success']) {
      _currentQuota = quotaRes['data'] as GuruQuotaModel;
    }

    if (historyRes['success']) {
      _currentMessages = List<GuruMessageModel>.from(historyRes['data']);
      emit(GuruChatLoaded(messages: _currentMessages, quota: _currentQuota!));
    } else {
      emit(GuruChatError(
        message: historyRes['message'] ?? 'Failed to load chat history',
        statusCode: historyRes['statusCode'],
        messages: _currentMessages,
        quota: _currentQuota,
      ));
    }
  }

  Future<void> _onCheckGuruQuota(
    CheckGuruQuota event,
    Emitter<GuruChatState> emit,
  ) async {
    final quotaRes = await GuruService.getGuruChatQuota();
    if (quotaRes['success']) {
      _currentQuota = quotaRes['data'] as GuruQuotaModel;
      if (state is GuruChatLoaded) {
        emit(GuruChatLoaded(messages: _currentMessages, quota: _currentQuota!));
      }
    }
  }

  Future<void> _onSendGuruMessage(
    SendGuruMessage event,
    Emitter<GuruChatState> emit,
  ) async {
    // Optimistically add the user message
    final userMessage = GuruMessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      role: 'user',
      content: event.message,
      createdAt: DateTime.now().toIso8601String(),
    );
    _currentMessages.add(userMessage);

    emit(GuruChatLoading(
      messages: _currentMessages,
      quota: _currentQuota,
      isSending: true,
    ));

    final res = await GuruService.sendGuruChatMessage(
      event.profileId,
      event.message,
      language: event.language,
    );

    if (res['success']) {
      // Message successfully sent and AI responded
      final assistantMessage = res['data'] as GuruMessageModel;
      _currentMessages.add(assistantMessage);
      
      // Re-check quota after a successful send
      add(CheckGuruQuota());
      
      emit(GuruChatLoaded(messages: _currentMessages, quota: _currentQuota!));
    } else {
      // Remove the optimistically added message on failure?
      // Optionally remove it or show an error state. For now, let's keep it but show error.
      _currentMessages.removeLast(); // Better to remove the unsent message
      
      emit(GuruChatError(
        message: res['message'] ?? 'Failed to send message',
        statusCode: res['statusCode'],
        messages: _currentMessages,
        quota: _currentQuota,
      ));
    }
  }
}
