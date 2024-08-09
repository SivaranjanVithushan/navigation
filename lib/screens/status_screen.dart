import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StatusProvider>().fetchStatuses());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StatusProvider>(
      builder: (context, statusProvider, child) {
        if (statusProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (statusProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${statusProvider.error}'));
        }
        return ListView.builder(
          itemCount: statusProvider.statuses.length,
          itemBuilder: (context, index) {
            final status = statusProvider.statuses[index];
            return ListTile(
              leading: CircleAvatar(child: Text(status.name[0])),
              title: Text(status.name),
              subtitle: Text(status.time),
            );
          },
        );
      },
    );
  }
}
