part of 'note_bloc.dart';

abstract class NoteState {}

final class NoteInitial extends NoteState {}

class NoteListUpdated extends NoteState {
  final List<Note> notes;

  NoteListUpdated(this.notes);

  @override
  String toString() => 'NoteListUpdated(notes: $notes)';
}

class NoteErrorState extends NoteState {
  final String error;

  NoteErrorState(this.error);
}

