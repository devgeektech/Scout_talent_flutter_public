import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';

class ChatScreenState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  ChatScreenState({required this.sharedPreferencesManager, required this.apiService});
}


// model Like ?
class ChatMessage {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isSender;

  ChatMessage({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isSender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      isSender: json['isSender'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isSender': isSender,
  };
}
