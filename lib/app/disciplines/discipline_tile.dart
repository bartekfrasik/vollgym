import 'package:flutter/material.dart';
import 'package:vollgym/app/exercises/exercises_page.dart';

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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExercisesPage(disciplineName: name)),
        );
      },
      child: Container(
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
      ),
    );
  }
}
