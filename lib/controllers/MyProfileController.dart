import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oiichat/View/AppBar.dart';
import 'package:oiichat/config/retrofit_api.dart';

import '../config/main_functions.dart';
import '../view/AppDrawer.dart';

class MyProfileController extends StatefulWidget {
  const MyProfileController({super.key});

  @override
  State<MyProfileController> createState() => _MyProfileControllerState();
}

class _MyProfileControllerState extends State<MyProfileController> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final apiService = MyApiService(Dio());
  String? user1;

  @override
  void initState() {
    super.initState();
    _handlePageLoad();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      user1 = userSessionData['userId']!;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_selectedImage!.path)));
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image selected!")));
      return;
    }

    try {
      final response = await apiService.uploadImage(_selectedImage!, user1!);
      print("Upload successful: $response");

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully!")));
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  String imageUrl = 'https://example.com/user_photo.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: OtherPageAppBar(your_title: "My Profile"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User photo section from URL
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(imageUrl), // Load image from URL
                    onBackgroundImageError: (error, stackTrace) {
                      // Handle error if image fails to load
                      print("Error loading image: $error");
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: () {
                        // Implement photo change functionality (e.g., open image picker)
                        _pickImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Name input field
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Bio input field
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
