import 'package:flutter/foundation.dart';
import 'package:notes/domain/repositories/repository.dart';

import '../../domain/entities/note.dart';
import '../../domain/usecases/addNote.dart';
import '../../domain/usecases/deleteNote.dart';
import '../../domain/usecases/editNote.dart';
import '../../domain/usecases/getAllNotes.dart';
import '../states/note_state.dart';

class NotesNotifier {
  late final GetAllNotes _getAllNotes;
  late final AddNote _addNote;
  late final DeleteNote _deleteNote;
  late final EditNote _editNote;

  final ValueNotifier<NotesState> stateNotifier = ValueNotifier(NotesLoading());

  NotesNotifier(Repository repository) {
    _getAllNotes = GetAllNotes(repository);
    _addNote = AddNote(repository);
    _deleteNote = DeleteNote(repository);
    _editNote = EditNote(repository);
  }

  NotesState get state => stateNotifier.value;

  /// Загрузка всех заметок
  Future<void> loadNotes() async {
    try {
      final notes = await _getAllNotes();
      stateNotifier.value = NotesLoaded(notes);
    } catch (e) {
      stateNotifier.value = NotesError('Ошибка загрузки: $e');
    }
  }

  /// Добавление новой заметки
  Future<void> add(String title, String content) async {
    try {
      final note = Note(
        id: -1, // временный id, Hive присвоит настоящий ключ
        title: title,
        content: content,
        date: DateTime.now(),
      );

      await _addNote(note);
      await loadNotes(); // обновляем список
    } catch (e) {
      stateNotifier.value = NotesError('Ошибка при добавлении: $e');
    }
  }

  /// Удаление заметки
  Future<void> delete(int id) async {
    try {
      await _deleteNote(id);
      await loadNotes(); // обновляем список
    } catch (e) {
      stateNotifier.value = NotesError('Ошибка при удалении: $e');
    }
  }

  /// Редактирование заметки
  Future<void> edit(Note note) async {
    try {
      await _editNote(note);
      await loadNotes(); // обновляем список
    } catch (e) {
      stateNotifier.value = NotesError('Ошибка при редактировании: $e');
    }
  }
}