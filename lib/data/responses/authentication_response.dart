import 'dart:convert';

class AuthenticationResponse {
  AuthenticationResponse({
    this.token,
  });

  String token;

  factory AuthenticationResponse.fromRawJson(String str) =>
      AuthenticationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponse(
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
      };
}
