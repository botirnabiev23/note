import 'dart:async';
import 'dart:convert';
import 'package:note_app/core/constants/local_storage_keys_constants.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _sharedPreferences;
  static final LocalStorage _instance = LocalStorage._internal();

  final _notesController = StreamController<List<Note>>.broadcast();

  Stream<List<Note>> get notesStream => _notesController.stream;

  LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final notes = await _instance.getNotes();
    _instance._notesController.add(notes);
  }

  Future<List<Note>> getNotes() async {
    final notesJson = _sharedPreferences.getStringList(
      LocalStorageKeysConstants.notes,
    );
    if (notesJson == null) return [];

    return notesJson.map((noteString) {
      return Note.fromJson(jsonDecode(noteString));
    }).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    await _sharedPreferences.setStringList(
      LocalStorageKeysConstants.notes,
      notesJson,
    );
    _notesController.add(notes);
  }

  Future<void> clearAllNotes() async {
    await _sharedPreferences.remove(LocalStorageKeysConstants.notes);
    _notesController.add([]);
  }

  void dispose() {
    _notesController.close();
  }
}
