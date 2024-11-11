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
                  padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // Background color
                ),
                child: Text(
                  btnName,
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
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
        decoration: InputDecoration(
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
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}