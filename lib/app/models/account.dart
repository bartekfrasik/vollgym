import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vollgym/app/utils/extensions.dart';

class Account {
  const Account({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    required this.email,
    this.avatar,
  });

  final String id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String email;
  final String? avatar;

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatar': avatar,
    };
  }

  Account copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? avatar,
  }) {
    return Account(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  String get getFullName {
    if (firstName != null && lastName != null) {
      return '${firstName!.capitalizeFirstLetter} ${lastName!.capitalizeFirstLetter}';
    } else if (firstName != null) {
      return firstName!.capitalizeFirstLetter;
    }

    return '-';
  }

  Image get getImage => Image.memory(base64Decode(avatar!));
  bool get isAvatarExists => avatar != null;
}

extension StringExt on String {
  String get capitalizeFirstLetter => this[0].toUpperCase() + substring(1);
}
