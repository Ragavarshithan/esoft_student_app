import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime parsedTime = DateTime.now();
    if (map['timestamp'] != null) {
      if (map['timestamp'] is Timestamp) {
        parsedTime = (map['timestamp'] as Timestamp).toDate();
      } else if (map['timestamp'] is int) {
        parsedTime = DateTime.fromMillisecondsSinceEpoch(map['timestamp']);
      }
    }
    
    return ChatMessage(
      id: documentId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: parsedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
