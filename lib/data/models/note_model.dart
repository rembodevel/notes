
import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';


@HiveType(typeId: 0) // Уникальный ID модели
class NoteModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  /// Преобразование из Entity в Data Model
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      date: note.date,
    );
  }

  /// Преобразование из Data Model в Entity
  Note toEntity(NoteModel noteModel) {
    return Note(
      id: noteModel.id,
      title: noteModel.title,
      content: noteModel.content,
      date: noteModel.date,
    );
  }
}


