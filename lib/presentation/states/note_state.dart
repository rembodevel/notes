
import '../../domain/entities/note.dart';

sealed class NotesState {}

// Состояние загрузки одной заметки
final class NotesLoading extends NotesState {}

// Состояние загрузки список заметок
final class NotesLoaded extends NotesState {
  final List<Note> notes;
  NotesLoaded(this.notes);
}

// Состояние ошибки
final class NotesError extends NotesState {
  final String message;
  NotesError(this.message);
}