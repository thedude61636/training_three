import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_three/providers/login_state.dart';
import 'package:training_three/screens/home_screen.dart';

String loginToken = "";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      lazy: false,
      create: (context) => LoginState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
