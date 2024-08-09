// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Status {
//   final String name;
//   final String time;

//   Status({required this.name, required this.time});

//   factory Status.fromJson(Map<String, dynamic> json) {
//     return Status(
//       name: json['name'],
//       time: json['time'],
//     );
//   }
// }

// class StatusProvider with ChangeNotifier {
//   List<Status> _statuses = [];
//   bool _isLoading = false;
//   String _error = '';

//   List<Status> get statuses => _statuses;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> fetchStatuses() async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response =
//           await http.get(Uri.parse('https://api.example.com/statuses'));
//       if (response.statusCode == 200) {
//         final List<dynamic> statusData = json.decode(response.body);
//         _statuses = statusData.map((data) => Status.fromJson(data)).toList();
//       } else {
//         _error = 'Failed to load statuses';
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

class Status {
  final String name;
  final String time;

  Status({required this.name, required this.time});
}

class StatusProvider with ChangeNotifier {
  List<Status> _statuses = [];
  bool _isLoading = false;
  String _error = '';
  Timer? _timer;

  List<Status> get statuses => _statuses;
  bool get isLoading => _isLoading;
  String get error => _error;

  StatusProvider() {
    _startListening();
  }

  void _startListening() {
    _timer = Timer.periodic(Duration(seconds: 10), (_) => _addNewStatus());
  }

  void _addNewStatus() {
    final newStatus = Status(
      name: "New User ${_statuses.length + 1}",
      time: "Just now",
    );
    _statuses.insert(0, newStatus);
    notifyListeners();
  }

  Future<void> fetchStatuses() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    try {
      _statuses = [
        Status(name: "John Doe", time: "Just now"),
        Status(name: "Jane Smith", time: "30 minutes ago"),
        Status(name: "Bob Johnson", time: "Today, 2:30 PM"),
        Status(name: "Alice Brown", time: "Today, 11:45 AM"),
        Status(name: "Charlie Wilson", time: "Yesterday, 8:00 PM"),
      ];
    } catch (e) {
      _error = "Error fetching statuses";
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
