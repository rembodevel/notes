import 'package:notes/domain/repositories/repository.dart';
import '../entities/note.dart';

final class AddNote {
  final Repository _repo;
  AddNote(this._repo);

  Future<void> call(Note note) => _repo.add(note);
}