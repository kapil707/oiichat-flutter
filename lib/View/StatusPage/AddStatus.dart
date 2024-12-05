import 'package:flutter/material.dart';
import 'package:oiichat/config/main_config.dart';

class AddStatus extends StatelessWidget {
  final String? your_id;
  final String? your_name;
  final String? your_image;

  const AddStatus({super.key, required this.your_id, required this.your_name, required this.your_image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(
                                MainConfig.image_url + your_image!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
                backgroundColor: Colors.black,
              radius: 10,
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      title: Text(your_name!),
      subtitle: const Text("Tab to add status update"),
    );
  }
}
