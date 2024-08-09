// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Call {
//   final String name;
//   final String type;
//   final String time;

//   Call({required this.name, required this.type, required this.time});

//   factory Call.fromJson(Map<String, dynamic> json) {
//     return Call(
//       name: json['name'],
//       type: json['type'],
//       time: json['time'],
//     );
//   }
// }

// class CallProvider with ChangeNotifier {
//   List<Call> _calls = [];
//   bool _isLoading = false;
//   String _error = '';

//   List<Call> get calls => _calls;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> fetchCalls() async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response =
//           await http.get(Uri.parse('https://api.example.com/calls'));
//       if (response.statusCode == 200) {
//         final List<dynamic> callData = json.decode(response.body);
//         _calls = callData.map((data) => Call.fromJson(data)).toList();
//       } else {
//         _error = 'Failed to load calls';
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

class Call {
  final String name;
  final String type;
  final String time;

  Call({required this.name, required this.type, required this.time});
}

class CallProvider with ChangeNotifier {
  List<Call> _calls = [];
  bool _isLoading = false;
  String _error = '';
  Timer? _timer;

  List<Call> get calls => _calls;
  bool get isLoading => _isLoading;
  String get error => _error;

  CallProvider() {
    _startListening();
  }

  void _startListening() {
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _addNewCall());
  }

  void _addNewCall() {
    final newCall = Call(
      name: "New User ${_calls.length + 1}",
      type: _calls.length % 2 == 0 ? "Audio" : "Video",
      time: "Just now",
    );
    _calls.insert(0, newCall);
    notifyListeners();
  }

  Future<void> fetchCalls() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      _calls = [
        Call(name: "John Doe", type: "Audio", time: "10 minutes ago"),
        Call(name: "Jane Smith", type: "Video", time: "30 minutes ago"),
        Call(name: "Bob Johnson", type: "Audio", time: "1 hour ago"),
        Call(name: "Alice Brown", type: "Video", time: "Yesterday, 8:30 PM"),
        Call(name: "Charlie Wilson", type: "Audio", time: "Yesterday, 3:15 PM"),
      ];
    } catch (e) {
      _error = "Error fetching calls";
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
