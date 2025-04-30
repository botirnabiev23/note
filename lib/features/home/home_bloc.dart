import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:note_app/core/services/local_storage/local_storage.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocalStorage _localStorage = LocalStorage();
  late final StreamSubscription<List<Note>> _notesSubscription;

  HomeBloc() : super(const HomeState()) {
    on<_DeleteNote>(_deleteNote);
    on<_EmitNotes>(_emitNotes);
    on<_GetAllNotes>(_getAllNotes);

    _notesSubscription = _localStorage.notesStream.listen((notes) {
      add(HomeEvent.emitNotes(notes));
    });
  }

  Future<void> _getAllNotes(
      _GetAllNotes event,
      Emitter<HomeState> emit,
      ) async {
    final allNotes = await _localStorage.getNotes();
    emit(state.copyWith(notes: allNotes));
  }

  Future<void> _deleteNote(
      _DeleteNote event,
      Emitter<HomeState> emit,
      ) async {
    final allNotes = await _localStorage.getNotes();
    allNotes.removeWhere((note) => note.id == event.noteId);
    await _localStorage.saveNotes(allNotes);
  }

  Future<void> _emitNotes(
      _EmitNotes event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(notes: event.notes));
  }

  @override
  Future<void> close() {
    _notesSubscription.cancel();
    return super.close();
  }
}
