import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyHomeWidget extends StatelessWidget {
  const EmptyHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              context.goNamed('addNotePage');
            },
            splashColor: Colors.transparent,
            child: Ink(
              child: const Image(
                image: AssetImage('assets/images/add_note.png'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create your first note!',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
