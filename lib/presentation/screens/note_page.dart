import 'package:flutter/material.dart';
import 'package:notes/domain/entities/note.dart';
import '../providers/notes_notifier.dart';

class NotePage extends StatefulWidget {
  final NotesNotifier notifier;
  final Note? note; // если null → добавление, если есть → редактирование

  const NotePage({super.key, required this.notifier, this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Редактировать заметку' : 'Новая заметка'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Сохранить',
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isEmpty && content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пустая заметка не будет сохранена')),
                  );
                  return;
                }

                if (isEdit) {
                  final updatedNote = widget.note!.copyWith(
                    title: title,
                    content: content,
                    date: DateTime.now(),
                  );
                  await widget.notifier.edit(updatedNote);
                } else {
                  await widget.notifier.add(title, content);
                }

                if (mounted) {
                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Содержание',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

extension on Note {
  Note copyWith({String? title, String? content, DateTime? date}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}