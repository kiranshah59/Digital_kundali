abstract class GuruChatEvent {}

class LoadGuruChat extends GuruChatEvent {
  final int profileId;
  LoadGuruChat(this.profileId);
}

class SendGuruMessage extends GuruChatEvent {
  final int profileId;
  final String message;
  final String language;

  SendGuruMessage({
    required this.profileId,
    required this.message,
    this.language = 'en',
  });
}

class CheckGuruQuota extends GuruChatEvent {}
