import 'package:hive/hive.dart';
import 'package:notes/data/models/note_data_model.dart';

abstract class NoteLocalDataSource {
  Future<void> add(NoteDataModel note);
  Future<void> delete(int id);
  Future<NoteDataModel?> getById(int id);
  Future<List<NoteDataModel>> getAll();
  Future<void> edit(NoteDataModel note);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<NoteDataModel> _box;

  NoteLocalDataSourceImpl(this._box);

  @override
  Future<void> add(NoteDataModel note) async {
    // создаём временную заметку без id
    final tempNote = NoteDataModel(
      id: -1,
      title: note.title,
      content: note.content,
      date: note.date,
    );

    // сохраняем и получаем уникальный ключ
    final key = await _box.add(tempNote);

    // пересохраняем заметку уже с правильным id
    final fixedNote = NoteDataModel(
      id: key,
      title: note.title,
      content: note.content,
      date: note.date,
    );
    await _box.put(key, fixedNote);
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  @override
  Future<List<NoteDataModel>> getAll() async {
    final notes = <NoteDataModel>[];
    for (var key in _box.keys) {
      final note = _box.get(key);
      if (note != null) {
        // синхронизируем id с ключом Hive
        note.id = key as int;
        notes.add(note);
      }
    }
    return notes;
  }

  @override
  Future<NoteDataModel?> getById(int id) async {
    final note = _box.get(id);
    if (note != null) {
      note.id = id; // на всякий случай синхронизация
    }
    return note;
  }

  @override
  Future<void> edit(NoteDataModel note) async {
    if (_box.containsKey(note.id)) {
      await _box.put(note.id, note);
    }
  }
}