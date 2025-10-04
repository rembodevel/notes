//? описали сущность (бизнес модель - логика которая заложена в самом приложение)
// прописали поля
class Note {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  Note({required this.id, required this.title, required this.content, required this.date});
}