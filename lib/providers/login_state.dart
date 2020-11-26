import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_three/data/dio_repo.dart';

class LoginState with ChangeNotifier {
  String _token = "";

  String get token => _token;

  set token(String token) {
    _token = token;
    if (token == null || token.isEmpty) {
      _deleteToken(token);
    } else {
      _setToken(token);
    }
    notifyListeners();
  }

  bool get isLoggedIn => token?.isNotEmpty ?? false;

  void _deleteToken(String token) async {
    DioRepo.removeToken();
    var sp = await SharedPreferences.getInstance();
    sp.remove(_tokenKey);
  }

  void _setToken(String token) async {
    DioRepo.setToken(token);

    var instance = await SharedPreferences.getInstance();
    instance.setString(_tokenKey, token);
  }

  static const String _tokenKey = "token";

  void _readTokenAndSet() async {
    var sharePreference = await SharedPreferences.getInstance();
    token = sharePreference.getString(_tokenKey);
  }

  LoginState() {
    _readTokenAndSet();
  }
}
