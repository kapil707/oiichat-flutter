import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  late final MyApiService apiService;
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
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No image selected!")));
      return;
    }

    try {
      final response = await apiService.uploadImage(user1!, _selectedImage!);
      print("Upload successful: $response");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")));
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  String imageUrl = 'https://example.com/user_photo.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
