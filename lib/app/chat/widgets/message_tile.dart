import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vollgym/app/models/coach.dart';
import 'package:vollgym/app/models/message.dart';
import 'package:vollgym/app/utils/extensions.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({
    super.key,
    required this.coach,
    required this.message,
  });

  final Coach coach;
  final Message message;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool showDate = false;

  bool get isCurrentUser => widget.message.authorId == FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    List<String> parts = widget.message.message
        .splitMapJoin(
          RegExp(r'(https?://\S+)'),
          onMatch: (m) => '${m.group(0)} ',
          onNonMatch: (n) => '$n ',
        )
        .split(' ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isCurrentUser) const SizedBox(width: 40),
          if (!isCurrentUser)
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 22.0,
              child: CircleAvatar(
                backgroundImage: widget.coach.isAvatarExists ? widget.coach.getImage.image : null,
                radius: 20.0,
                child: widget.coach.isAvatarExists ? null : Text(widget.coach.getFirstNameLetter),
              ),
            ),
          const SizedBox(width: 15),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showDate = !showDate;
                });
              },
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: parts.map((part) {
                          if (part.trim().startsWith('http')) {
                            return TextSpan(
                              text: '$part ',
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(part));
                                },
                            );
                          }

                          final partLength = part.trim().length;
                          if (int.tryParse(part.trim().replaceAll('+', '')) != null &&
                              (partLength == 9 || partLength == 11 || partLength == 12)) {
                            return TextSpan(
                              text: '$part ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri(scheme: 'tel', path: part));
                                },
                            );
                          }

                          return TextSpan(
                            text: '$part ',
                            style: const TextStyle(color: Colors.black),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (showDate)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 5),
                      child: Text(
                        '${widget.message.sendDate.day} ${widget.message.sendDate.month.toMonthNameShort}, ${widget.message.sendDate.hour}:${widget.message.sendDate.minute}',
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isCurrentUser) const SizedBox(width: 40),
        ],
      ),
    );
  }
}
