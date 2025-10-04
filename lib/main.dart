import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/data/models/note_data_model.dart';
import 'package:notes/presentation/screens/home_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive
  await Hive.initFlutter();

  // Регистрируем адаптер модели, если не был зарегистрирован
  Hive.registerAdapter(NoteDataModelAdapter());

  // Открываем коробку
  final box = await Hive.openBox<NoteDataModel>('notes_box');

  // Запускаем приложение с передачей box
  runApp(ProviderScope(child: MyApp(box)));
}

//dart run build_runner build - команда для генерации адаптеров Hive
//dart run build_runner build --delete-conflicting-outputs - команда для генерации адаптеров Hive с удалением конфликтующих выходных данных


class MyApp extends StatelessWidget {
  final Box<NoteDataModel> box;

  const MyApp(this.box, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(box),
    );
  }
}
