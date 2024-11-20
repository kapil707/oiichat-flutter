import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String btnName;
  final VoidCallback? callBack;

  const MainButton({super.key, required this.btnName, this.callBack});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle login logic here
        callBack!();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Background color
      ),
      child: Text(
        btnName,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

class MainTextboxWithIcon extends StatelessWidget {
  final TextEditingController mytextController;
  final Icon? btnIcon;
  final String? btnName;

  const MainTextboxWithIcon(
      {super.key, required this.mytextController, this.btnIcon, this.btnName});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mytextController,
      decoration: InputDecoration(
        labelText: btnName,
        border: const OutlineInputBorder(),
        prefixIcon: btnIcon,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class MainEmailbox extends StatelessWidget {
  final TextEditingController mytextController;

  const MainEmailbox({super.key, required this.mytextController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mytextController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class MainPasswordbox extends StatelessWidget {
  final TextEditingController mytextController;

  const MainPasswordbox({super.key, required this.mytextController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mytextController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}

class MainErrorLabel extends StatelessWidget {
  final String? message;

  const MainErrorLabel({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        : const SizedBox.shrink(); // Empty widget if message is null
  }
}

class ChatInputBox extends StatelessWidget {
  final TextEditingController messageController;
  final Function onSend;
  final FocusNode messageFocus;

  ChatInputBox({required this.messageController, required this.onSend, required this.messageFocus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Attachment Icon
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
            onPressed: () {
              // Handle attachment
            },
          ),
          // Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      focusNode: messageFocus,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Emoji Icon
                  IconButton(
                    icon: Icon(Icons.emoji_emotions, color: Colors.grey.shade600),
                    onPressed: () {
                      // Handle emoji picker
                    },
                  ),
                ],
              ),
            ),
          ),
          // Send Button
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                onSend(); // Call the send function
              }
            },
          ),
        ],
      ),
    );
  }
}
