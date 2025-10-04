import '../entities/note.dart';

abstract class Repository {
  Future<void> add(Note note);
  Future<void> delete(int id);
  Future<void> edit(Note note);
  Future<Note?> getById(int id);
  Future<List<Note>> getAllNotes();
}