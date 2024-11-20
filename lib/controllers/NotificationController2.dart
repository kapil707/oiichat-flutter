import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/models/NotificationModel.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/NotificationService.dart';

class NotificationController2 extends StatefulWidget {
  const NotificationController2({super.key});

  @override
  State<NotificationController2> createState() =>
      _NotificationController2State();
}

class _NotificationController2State extends State<NotificationController2> {
  final apiService = MyApiService(Dio());
  final bool _isLoading = false;

  late Future<NotificationModel> _notificationsFuture;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    //notificationService = NotificationService(apiService);
    //_notificationsFuture = notificationService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: CustomScrollView(
          slivers: [
            //SliverAppBar
            SliverAppBar(
              leading: const Icon(Icons.menu),
              expandedHeight: 300,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Jai Mata di"),
                background: Container(
                  color: Colors.brown,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.black,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.black,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.black,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.black,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
}
