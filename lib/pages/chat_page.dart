import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener((){
      if (myFocusNode.hasFocus){
        // cause a delay so that the keyboard has time to show up
        // then the amount of remaining space wll be calculated
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500),
            () => scrollDown(),
        );
      }
    });

    // wait a bit for listview to be built, then scroll to bottom
    Future.delayed(
      const Duration(
          milliseconds: 500),
          () => scrollDown(),
    );
  }
  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
    );
  }


  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.trim().isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
          widget.receiverID,
          _messageController.text.trim()
      );

      // clear the controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            title: Text(widget.receiverEmail),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey,
            elevation: 0,
        ),
      body: Column(
        children: [
          // display all messages
          Expanded(
              child: _buildMessageList()
          ),

          // users input
          _buildUserInput(),
        ],
      ),
    );
  }

    // build message list
    Widget _buildMessageList() {
      String senderID = _authService.getCurrentUser()!.uid;
      return StreamBuilder(
          stream: _chatService.getMessages(widget.receiverID, senderID),
          builder: (context, snapshot) {
            // errors
            if (snapshot.hasError){
              return const Text("Error");
            }
            // loading
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Text("Loading..");
            }
            // return list view
            return ListView(
              controller: _scrollController,
              children:
                  snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
            );
          },
      );

  }

  // build message Item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
    // is current user
    bool isCurrentUser =data['senderID'] == _authService.getCurrentUser()!.uid;
    // align message to the right if sender is the current user, otherwise left
    var alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
                message: data["message"],
                isCurrentUser: isCurrentUser
            ),
          ],
        ));
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Type your message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // send button
          Container(
            decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
