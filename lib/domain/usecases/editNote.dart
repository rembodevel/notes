
import 'package:notes/domain/repositories/repository.dart';

import '../entities/note.dart';

class EditNote {
  final Repository _repo;
  EditNote(this._repo);

  Future<void> call(Note note) => _repo.edit(note);
}