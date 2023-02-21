import 'package:flutter/material.dart';

class DisciplineTile extends StatelessWidget {
  const DisciplineTile({
    super.key,
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  final String id;
  final String name;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
          image: NetworkImage(photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(name, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
