import 'dart:convert';

import 'package:flutter/material.dart';

class Coach {
  const Coach({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? avatar;

  factory Coach.fromMap(Map<String, dynamic> map) {
    return Coach(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      avatar: map['avatar'],
    );
  }

  String get getFullName => '$firstName $lastName';
  String get getFirstNameLetter => firstName[0];
  Image get getImage => Image.memory(base64Decode(avatar!));
  bool get isAvatarExists => avatar != null;
}
