import '../models/guru_message_model.dart';
import '../models/guru_quota_model.dart';

abstract class GuruChatState {}

class GuruChatInitial extends GuruChatState {}

class GuruChatLoading extends GuruChatState {
  final List<GuruMessageModel> messages;
  final GuruQuotaModel? quota;
  final bool isSending; // true if waiting for AI response

  GuruChatLoading({
    required this.messages,
    this.quota,
    this.isSending = false,
  });
}

class GuruChatLoaded extends GuruChatState {
  final List<GuruMessageModel> messages;
  final GuruQuotaModel quota;

  GuruChatLoaded({
    required this.messages,
    required this.quota,
  });
}

class GuruChatError extends GuruChatState {
  final String message;
  final int? statusCode;
  final List<GuruMessageModel> messages; // Preserve history if error happens
  final GuruQuotaModel? quota;

  GuruChatError({
    required this.message,
    this.statusCode,
    this.messages = const [],
    this.quota,
  });
}
