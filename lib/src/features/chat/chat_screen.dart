import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/chat_service.dart';
import '../../services/mock_data_service.dart';
import '../../models/user.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<AppUser> user = [ const AppUser(id: 'a1', name: 'Admin Flow', email: 'admin@esoft.lk', role: UserRole.admin)];
  final TextEditingController _controller = TextEditingController();
  AppUser? _selectedRecipient;

  void _sendMessage(AppUser currentUser) {
    if (_controller.text.trim().isNotEmpty && _selectedRecipient != null) {
      ref.read(chatServiceProvider).sendMessage(
            currentUser.id,
            _selectedRecipient!.id,
            _controller.text.trim(),
          );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = user?.first;
    final mockService = ref.watch(mockDataServiceProvider);
    
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Please log in first')));
    }

    // Fetch available users to chat with (excluding current user)
    final availableUsers = mockService.users
        .where((user) => user.id != currentUser.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Recipient Selection Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            ),
            child: Row(
              children: [
                const Text('To: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AppUser>(
                      value: _selectedRecipient,
                      hint: const Text('Select a recipient to start chatting'),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: availableUsers.map((AppUser user) {
                        return DropdownMenuItem<AppUser>(
                          value: user,
                          child: Text('${user.name} (${user.role.name.toUpperCase()})'),
                        );
                      }).toList(),
                      onChanged: (AppUser? newValue) {
                        setState(() {
                          _selectedRecipient = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Messages Area
          Expanded(
            child: _selectedRecipient == null
                ? const Center(
                    child: Text(
                      'Please select a recipient from the top menu to start a conversation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : StreamBuilder(
                    stream: ref.read(chatServiceProvider).getMessages(currentUser.id, _selectedRecipient!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data ?? [];

                      if (messages.isEmpty) {
                        return const Center(child: Text('No messages yet. Say hi!'));
                      }

                      return ListView.builder(
                        reverse: true, // Show newest at the bottom
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser.id;

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFF1E3A8A) : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('HH:mm').format(message.timestamp),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: _selectedRecipient != null,
                      decoration: InputDecoration(
                        hintText: _selectedRecipient != null ? 'Type a message...' : 'Select recipient first',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _sendMessage(currentUser),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: _selectedRecipient != null ? const Color(0xFF1E3A8A) : Colors.grey,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _selectedRecipient != null ? () => _sendMessage(currentUser) : null,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
