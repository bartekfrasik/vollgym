import 'package:flutter/material.dart';

class AccountTileData {
  const AccountTileData({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final VoidCallback onPressed;
}
