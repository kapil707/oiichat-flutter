
import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {

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
                    backgroundImage: NetworkImage(imageUrl), // Load image from URL
                    onBackgroundImageError: (error, stackTrace) {
                      // Handle error if image fails to load
                      print("Error loading image: $error");
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: () {
                        // Implement photo change functionality (e.g., open image picker)
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Name input field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Bio input field
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      );
  }
}