import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  Get stream of all users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        user['uid'] = doc.id; // to include user ID
        return user;
      }).toList();
    });
  }


  //  Send message
  Future<void> sendMessage(String receiverID, String message) async {
    // 1. Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    /*print("Sending message...");
    print("ReceiverID: $receiverID");
    print("Message: $message");
    print("Current user ID: $_auth.currentUser!.uid");
    */

    // 2. Create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // 3. Create chatRoomID (must use same logic in both send & read)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // ensures same order for both users
    String chatRoomID = ids.join('_');

    // 4. Save message to Firestore
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());


  }

  //  Get messages between current user and other user
  Stream<QuerySnapshot> getMessages(String userId, String otherUserID) {
    List<String> ids = [userId, otherUserID];
    ids.sort(); // must match sendMessage order
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
