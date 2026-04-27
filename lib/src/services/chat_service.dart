import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper function to create a unique chat ID between two users
  String getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  // Get stream of messages for a chat room
  Stream<List<ChatMessage>> getMessages(String currentUserId, String recipientId) {
    String chatRoomId = getChatRoomId(currentUserId, recipientId);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Send a new message
  Future<void> sendMessage(String currentUserId, String recipientId, String text) async {
    String chatRoomId = getChatRoomId(currentUserId, recipientId);
    
    // Add the message to the messages subcollection
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally update the parent document to track participants or last message
    await _firestore.collection('chats').doc(chatRoomId).set({
      'participants': [currentUserId, recipientId],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

// Provider for the chat service
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});
