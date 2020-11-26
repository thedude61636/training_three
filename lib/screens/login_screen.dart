import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_three/data/responses/authentication_response.dart';
import 'package:training_three/main.dart';
import 'package:training_three/providers/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "something@something.com",
                    labelText: "Email:",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "***********",
                    labelText: "Password:",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                  child: Text("Login"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    login(username, password);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(String username, String password) async {
    print([username, password]);
    var dio = Dio();
    var response = await dio.post("https://10.0.2.2:5001/api/v1/identity/login",
        data: {"username": username, "password": password});
    print(response.data);
    var loginToken = AuthenticationResponse.fromJson(response.data).token;
    var loginState = Provider.of<LoginState>(context, listen: false);
    loginState.token = loginToken;

    Navigator.pop(context);
  }
}
