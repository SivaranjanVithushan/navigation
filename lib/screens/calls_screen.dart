import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';

class CallsScreen extends StatefulWidget {
  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CallProvider>().fetchCalls());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        if (callProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (callProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${callProvider.error}'));
        }
        return ListView.builder(
          itemCount: callProvider.calls.length,
          itemBuilder: (context, index) {
            final call = callProvider.calls[index];
            return ListTile(
              leading: CircleAvatar(child: Text(call.name[0])),
              title: Text(call.name),
              subtitle: Text('${call.type} • ${call.time}'),
              trailing:
                  Icon(call.type == 'Audio' ? Icons.call : Icons.videocam),
            );
          },
        );
      },
    );
  }
}
