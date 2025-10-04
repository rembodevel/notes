
import 'package:notes/domain/repositories/repository.dart';

class DeleteNote {
  final Repository _repo;
  DeleteNote(this._repo);

  Future<void> call(int id) => _repo.delete(id);
}