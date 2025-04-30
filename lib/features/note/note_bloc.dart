import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:note_app/core/services/local_storage/local_storage.dart';
import 'package:uuid/uuid.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final LocalStorage _localStorage = LocalStorage();
  final Uuid uuid = const Uuid();

  NoteBloc() : super(NoteInitial()) {
    on<TextAddedEvent>(_addNote);
    on<NoteUpdatedEvent>(_editNote);
  }

  Future<void> _addNote(TextAddedEvent event, Emitter emit) async {
    try {
      final existingNotes = await _localStorage.getNotes();
      final newNote = Note(
        id: uuid.v4(),
        title: event.title,
        subtitle: event.subtitle,
        imagePaths: event.imagePaths,
      );
      existingNotes.add(newNote);
      await _localStorage.saveNotes(existingNotes);
      emit(NoteListUpdated(List.from(existingNotes)));
    } catch (_) {
      emit(NoteErrorState('Failed to add note'));
    }
  }

  Future<void> _editNote(NoteUpdatedEvent event, Emitter emit) async {
    try {
      final allNotes = await _localStorage.getNotes();
      final updatedNotes = allNotes.map((note) {
        return note.id == event.note.id ? event.note : note;
      }).toList();
      await _localStorage.saveNotes(updatedNotes);
      emit(NoteListUpdated(updatedNotes));
    } catch (_) {
      emit(NoteErrorState('Failed to edit note'));
    }
  }
}

