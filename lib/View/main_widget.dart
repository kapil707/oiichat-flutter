import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/Config/Colors.dart';

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
        backgroundColor: mainBtnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Background color
      ),
      child: Text(
        btnName,
        style: const TextStyle(fontSize: 18, color: mainBtnTxtColor),
      ),
    );
  }
}

class MainTextboxWithIcon extends StatelessWidget {
  final TextEditingController mytextController;
  final Icon? btnIcon;
  final String? btnName;
  final String? btnNamehint;

  const MainTextboxWithIcon(
      {super.key,
      required this.mytextController,
      this.btnIcon,
      this.btnName,
      this.btnNamehint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mytextController,
      decoration: InputDecoration(
        //labelText: btnName,
        hintText: btnNamehint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColorE), // Default border color
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColor), // Border color when focused
        ),
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
        //labelText: 'Email', // Hint text
        hintText: 'Enter your email', // Additional hint text
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColorE), // Default border color
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColor), // Border color when focused
        ),
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
        //labelText: 'Email', // Hint text
        hintText: 'Enter your password', // Additional hint text
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColorE), // Default border color
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainTextboxBorderColor), // Border color when focused
        ),
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

class ChatInputBox extends StatefulWidget {
  final TextEditingController messageController;
  final Function onSend;
  final FocusNode messageFocus;
  final Function emojiOpen;
  final Function(int typingStatus) onTypingStatus; // Callback for typing status

  const ChatInputBox({
    super.key,
    required this.messageController,
    required this.onSend,
    required this.messageFocus,
    required this.emojiOpen,
    required this.onTypingStatus,
  });

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  @override
  void initState() {
    super.initState();
    // Add listener to monitor changes in the text field
    widget.messageController.addListener(_handleTypingStatus);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    widget.messageController.removeListener(_handleTypingStatus);
    super.dispose();
  }

  void _handleTypingStatus() {
    if (widget.messageController.text.isNotEmpty) {
      widget.onTypingStatus(1); // User is typing
    } else {
      widget.onTypingStatus(0); // Text field is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          child: Card(
            margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              focusNode: widget.messageFocus,
              controller: widget.messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(5),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.emoji_emotions),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        // Send Button
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 5,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: mainBtnColor,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (widget.messageController.text.isNotEmpty) {
                  widget.onSend(); // Call the send function
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
