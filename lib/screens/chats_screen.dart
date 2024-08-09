import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ChatProvider>().fetchChats());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (chatProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${chatProvider.error}'));
        }
        return ListView.builder(
          itemCount: chatProvider.chats.length,
          itemBuilder: (context, index) {
            final chat = chatProvider.chats[index];
            return ListTile(
              leading: CircleAvatar(child: Text(chat.name[0])),
              title: Text(chat.name),
              subtitle: Text(chat.lastMessage),
              trailing: Text(chat.time),
            );
          },
        );
      },
    );
  }
}
