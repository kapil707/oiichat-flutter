import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/controllers/NotificationController.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/models/NotificationModel.dart';
import 'package:oiichat/retrofit_api.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  
  final apiService = MyApiService(Dio());
  late final HomeController authService;
  bool _isLoading = false;

  late Future<NotificationModel> _notificationsFuture;
  late NotificationController notificationController;
   
  @override
  void initState() {
    super.initState();
    notificationController = NotificationController(apiService); 
    _notificationsFuture = notificationController.fetchNotifications(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [ Text("NotificationPage"),
          if (_isLoading)...{
              Center(
                child: CircularProgressIndicator(),
            ),
          },
        ]),
      ),
      body: FutureBuilder<NotificationModel>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items!.isEmpty) {
            return Center(child: Text('No notifications found'));
          }

          final items = snapshot.data!.items!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(item.itemImage ?? ''),
                title: Text(item.itemTitle ?? ''),
                subtitle: Text('${item.itemMessage}\n${item.itemDateTime}'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}