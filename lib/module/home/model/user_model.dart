// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.users,
  });

  List<User>? users;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.id,
    this.createdAt,
    this.email,
    this.firstName,
    this.lastName,
    this.updatedAt,
    this.bio,
  });

  int? id;
  String? createdAt;
  String? email;
  String? firstName;
  String? lastName;
  String? updatedAt;
  String? bio;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      createdAt: json["created_at"].toString(),
      email: json["email"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      updatedAt: json["updated_at"].toString(),
      bio: json["bio"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "updated_at": updatedAt,
        "bio": bio
      };
}
