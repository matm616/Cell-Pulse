import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Cell Pulse LiPo App',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Text(
              'Always a work in progress...',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}