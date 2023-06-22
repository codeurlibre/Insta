import 'package:flutter/material.dart';

import '../widgets/header_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Notification"),
      body: const Center(
        child: Text("Notification page"),
      ),
    );
  }
}


class NotificationsItem extends StatelessWidget {
  const NotificationsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
