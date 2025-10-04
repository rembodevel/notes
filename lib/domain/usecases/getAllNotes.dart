
import 'package:notes/domain/repositories/repository.dart';
import '../entities/note.dart';


class GetAllNotes {
  final Repository _repo;
  GetAllNotes(this._repo);

  Future<List<Note>> call() => _repo.getAllNotes();
}