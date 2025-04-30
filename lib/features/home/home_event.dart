part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.getAllNotes() = _GetAllNotes;
  const factory HomeEvent.deleteNote(String noteId) = _DeleteNote;
  const factory HomeEvent.emitNotes(List<Note> notes) = _EmitNotes;
}


