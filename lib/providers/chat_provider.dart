// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Chat {
//   final String name;
//   final String lastMessage;
//   final String time;

//   Chat({required this.name, required this.lastMessage, required this.time});

//   factory Chat.fromJson(Map<String, dynamic> json) {
//     return Chat(
//       name: json['name'],
//       lastMessage: json['lastMessage'],
//       time: json['time'],
//     );
//   }
// }

// class ChatProvider with ChangeNotifier {
//   List<Chat> _chats = [];
//   bool _isLoading = false;
//   String _error = '';

//   List<Chat> get chats => _chats;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> fetchChats() async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response =
//           await http.get(Uri.parse('https://api.example.com/chats'));
//       if (response.statusCode == 200) {
//         final List<dynamic> chatData = json.decode(response.body);
//         _chats = chatData.map((data) => Chat.fromJson(data)).toList();
//       } else {
//         _error = 'Failed to load chats';
//       }
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'dart:async';

class Chat {
  final String name;
  final String lastMessage;
  final String time;

  Chat({required this.name, required this.lastMessage, required this.time});
}

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  bool _isLoading = false;
  String _error = '';
  Timer? _timer;

  List<Chat> get chats => _chats;
  bool get isLoading => _isLoading;
  String get error => _error;

  ChatProvider() {
    // Start listening for updates when the provider is created
    _startListening();
  }

  void _startListening() {
    // Simulate receiving updates every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _addNewChat());
  }

  void _addNewChat() {
    final newChat = Chat(
      name: "New User ${_chats.length + 1}",
      lastMessage: "Hello! This is a new message.",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
    );
    _chats.insert(0, newChat);
    notifyListeners();
  }

  Future<void> fetchChats() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    try {
      _chats = [
        Chat(
            name: "John Doe",
            lastMessage: "Hey, how are you?",
            time: "10:30 AM"),
        Chat(
            name: "Jane Smith",
            lastMessage: "Did you see the news?",
            time: "9:45 AM"),
        Chat(
            name: "Bob Johnson",
            lastMessage: "Meeting at 2 PM",
            time: "Yesterday"),
        Chat(
            name: "Alice Brown",
            lastMessage: "Thanks for the help!",
            time: "Yesterday"),
        Chat(
            name: "Charlie Wilson",
            lastMessage: "Let's catch up soon",
            time: "2 days ago"),
      ];
    } catch (e) {
      _error = "Error fetching chats";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
