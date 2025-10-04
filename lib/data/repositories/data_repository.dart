

import 'package:notes/data/models/note_data_model.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/repositories/repository.dart';
import '../dataSource/note_data_source.dart';

class DataRepository implements Repository{
  NoteLocalDataSource localDataSource;
  DataRepository(this.localDataSource);

  @override
  Future<void> add(Note note) async {
    localDataSource.add(NoteDataModel.fromEntity(note));
  }

  @override
  Future<void> delete(int id) async {
    localDataSource.delete(id);
  }

  @override
  Future<void> edit(Note note) async {
    localDataSource.edit(NoteDataModel.fromEntity(note));
  }

  @override
  Future<List<Note>> getAllNotes() async {
    return (await localDataSource.getAll()).map((m)=> m.toEntity()).toList();
  }

  @override
  Future<Note?> getById(int id) async{
    return (await localDataSource.getById(id))?.toEntity();
  }
}