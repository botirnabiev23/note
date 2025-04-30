import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/model/note_model.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        context.goNamed(
          'editNotePage',
          extra: note,
        );
      },
      child: Ink(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            color: Colors.blue,
          ),
          child: Text(
            note.title,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
