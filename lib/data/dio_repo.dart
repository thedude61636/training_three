import 'package:dio/dio.dart';

class DioRepo {
  static Dio _dio;

  static Dio getDio() {
    if (_dio == null) {
      // 10.0.2.2 is the local host of your machine instead of the emulator
      _dio = Dio(BaseOptions(baseUrl: "https://10.0.2.2:5001/api/v1/"));
    }

    return _dio;
  }

  static void setToken(String token) {
    getDio().options.headers["Authorization"] = "Bearer $token";
    print("token got set");
  }

  static void removeToken() {
    getDio().options.headers.remove("Authorization");
  }

  static void setLanguage(String language) {
    getDio().options.headers["Language"] = language;
  }
}
