import 'package:hive/hive.dart';

import '../../domain/entities/note.dart';
part 'note_data_model.g.dart';

@HiveType(typeId: 0)
class NoteDataModel extends HiveObject {
  // аннотация поля
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime date;

  NoteDataModel({required this.id, required this.title, required this.content, required this.date});

  // Создает NoteDataModel из Note (Entity)
  factory NoteDataModel.fromEntity(Note note) => NoteDataModel(
     id: note.id,
     title: note.title,
     content: note.content,
     date: note.date,
   );

   // Преобразует NoteDataModel обратно в Note (Entity)
  Note toEntity() => Note(id: id, title: title, content: content, date: date);
}