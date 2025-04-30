import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String subtitle;
  final List<String> imagePaths;

  Note({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePaths,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    var imagePathsFromJson = json['imagePaths'] != null
        ? List<String>.from(json['imagePaths'])
        : <String>[];

    return Note(
      id: json['id'] ?? const Uuid().v4(),
      title: json['title'],
      subtitle: json['content'],
      imagePaths: imagePathsFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': subtitle,
      'imagePaths': imagePaths,
    };
  }
}
