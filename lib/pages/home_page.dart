import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import '../components/user_tile.dart';
import '../services/chat/chat_service.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // Build a list of users except the current logged-in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading users."));
        }

        // Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading users..."));
        }

        // Return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // Build individual list tile for a user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // Current user email
    final currentUserEmail = _authService.getCurrentUser()?.email;

    // Skip current user
    if (userData["email"] != currentUserEmail) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          // Navigate to ChatPage with both email and UID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"], // Make sure this field exists!
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Empty widget for current user
    }
  }
}
