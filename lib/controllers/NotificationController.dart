import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/models/NotificationModel.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/NotificationService.dart';

class NotificationController extends StatefulWidget {
  @override
  State<NotificationController> createState() => _NotificationControllerState();
}

class _NotificationControllerState extends State<NotificationController> {
  
  final apiService = MyApiService(Dio());
  bool _isLoading = false;

  late Future<NotificationModel> _notificationsFuture;
  late NotificationService notificationService;
   
  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(apiService); 
    _notificationsFuture = notificationService.fetchNotifications(); 
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