import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/notification_viewModel.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NotificationViewModel>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: vm.currentTabIndex,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Notification'),
          bottom: TabBar(
            onTap: vm.setTab,
            tabs: const [
              Tab(text: 'For you'),
              Tab(text: 'Inbox'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('For you content')),
            Center(child: Text('Inbox content')),
          ],
        ),
      ),
    );
  }
}
