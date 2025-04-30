import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/features/note/note_bloc.dart';
import 'package:note_app/pages/widgets/custom_back_button.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  bool isEditing = false;

  final ImagePicker picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImage() async {
    setState(() {
      isEditing = true;
    });
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFiles.add(picked);
      });
    }
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
          if (isEditing)
            InkWell(
              onTap: () {
                final title = titleController.text.trim();
                final subtitle = subtitleController.text.trim();
                FocusScope.of(context).unfocus();
                if (title.isNotEmpty ||
                    subtitle.isNotEmpty ||
                    _imageFiles.isNotEmpty) {
                  context.read<NoteBloc>().add(
                        TextAddedEvent(
                          title,
                          subtitle,
                          _imageFiles.map((file) => file.path).toList(),
                        ),
                      );
                  setState(() {
                    isEditing = false;
                  });
                }
              },
              child: Ink(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                    color: Color(0xff3B3B3B),
                  ),
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              TextField(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 34,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                controller: subtitleController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              if (_imageFiles.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _imageFiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final file = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(file.path),
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
                              onTap: () {
                                setState(() {
                                  _imageFiles.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Color(0xff252525),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
