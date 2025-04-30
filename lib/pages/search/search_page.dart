import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:note_app/features/home/home_bloc.dart';
import 'package:note_app/pages/home/widgets/note_item_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  String searchQuery = '';
  bool isTyping = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: TextField(
            onTap: () {
              setState(() {
                isTyping = true;
              });
            },
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search by keyword',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(38),
                ),
              ),
              suffixIcon: isTyping
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isTyping = false;
                          controller.clear();
                          searchQuery = '';
                        });
                      },
                      icon: Icon(Icons.close),
                    )
                  : null,
            ),
            onChanged: (query) {
              setState(() {
                searchQuery = query.toLowerCase();
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: Text('Cancel'),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final filteredNotes = state.notes
              .where((note) =>
                  note.title.toLowerCase().contains(searchQuery) ||
                  note.subtitle.toLowerCase().contains(searchQuery))
              .toList();

          if (filteredNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/search_page.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'File not found. Try searching again.',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final Note note = filteredNotes[index];
              return NoteItem(note: note);
            },
          );
        },
      ),
    );
  }
}
