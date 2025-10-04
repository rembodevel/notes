import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes/data/dataSource/note_data_source.dart';
import 'package:notes/data/models/note_data_model.dart';
import 'package:notes/data/repositories/data_repository.dart';
import 'package:notes/domain/repositories/repository.dart';
import 'package:notes/presentation/providers/notes_notifier.dart';

import '../states/note_state.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  final Box<NoteDataModel> box;

  const HomePage(this.box, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NotesNotifier notesNotifier;

  @override
  void initState() {
    super.initState();
    final NoteLocalDataSource localDataSource = NoteLocalDataSourceImpl(widget.box);
    final Repository repository = DataRepository(localDataSource);
    notesNotifier = NotesNotifier(repository);
    notesNotifier.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки'), centerTitle: true),
      body: ValueListenableBuilder<NotesState>(
        valueListenable: notesNotifier.stateNotifier,
        builder: (context, state, _) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesError) {
            return Center(child: Text(state.message));
          } else if (state is NotesLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('Нет заметок'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content.length > 100
                        ? '${note.content.substring(0, 100)}...'
                        : note.content,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(
                        context: context,
                        onConfirm: () async {
                          await notesNotifier.delete(note.id); // ✅ теперь int
                        },
                      );
                    },
                  ),
                  onTap: () async {
                    // переход к редактированию заметки
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotePage(
                          notifier: notesNotifier,
                          note: note, // передаём заметку
                        ),
                      ),
                    );
                    if (result == true) {
                      await notesNotifier.loadNotes();
                    }
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(notifier: notesNotifier),
            ),
          );
          if (result == true) {
            await notesNotifier.loadNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Удалить заметку'),
          content: const Text('Вы уверены, что хотите удалить эту заметку?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}