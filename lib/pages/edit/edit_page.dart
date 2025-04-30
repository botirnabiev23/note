import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:note_app/features/note/note_bloc.dart';
import 'package:note_app/pages/widgets/custom_back_button.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  const EditNotePage({
    super.key,
    required this.note,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  bool isEditing = false;
  final ImagePicker _picker = ImagePicker();
  late List<String> _imagePaths;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _subtitleController = TextEditingController(text: widget.note.subtitle);
    _imagePaths = List<String>.from(widget.note.imagePaths);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePaths.add(picked.path);
        isEditing = true;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Transform.translate(
          offset: Offset(10, 0),
          child: CustomBackButton(),
        ),
        actions: [
          if (!isEditing)
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => isEditing = true),
                  child: Ink(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Color(0xff3B3B3B),
                      ),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          if (isEditing)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final updatedTitle = _titleController.text.trim();
                    final updatedSubtitle = _subtitleController.text.trim();

                    final Note updatedNote = Note(
                      id: widget.note.id,
                      title: updatedTitle,
                      subtitle: updatedSubtitle,
                      imagePaths: _imagePaths,
                    );

                    FocusScope.of(context).unfocus();
                    if (updatedTitle.isNotEmpty || updatedSubtitle.isNotEmpty) {
                      context.read<NoteBloc>().add(NoteUpdatedEvent(updatedNote));
                      setState(() => isEditing = false);
                    }
                  },
                  child: Ink(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Color(0xff3B3B3B),
                      ),
                      child: Icon(Icons.save, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onTap: () => setState(() => isEditing = true),
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 34),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onTap: () => setState(() => isEditing = true),
                controller: _subtitleController,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              if (_imagePaths.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _imagePaths
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final path = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(path),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isEditing)
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  })
                      .toList(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Color(0xff252525),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        child: Icon(Icons.image, color: Colors.white),
      )
          : null,
    );
  }
}
