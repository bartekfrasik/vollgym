import 'package:flutter/material.dart';
import 'package:vollgym/app/models/coach.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.coach,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Coach coach;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 22.0,
          child: CircleAvatar(
            backgroundImage: coach.isAvatarExists ? coach.getImage.image : null,
            radius: 20.0,
            child: coach.isAvatarExists ? null : Text(coach.getFirstNameLetter),
          ),
        ),
        title: Text(coach.getFullName),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: trailing != null ? Text(trailing!) : null,
      ),
    );
  }
}
