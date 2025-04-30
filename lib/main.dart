import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/model/note_model.dart';
import 'package:note_app/core/services/local_storage/local_storage.dart';
import 'package:note_app/features/home/home_bloc.dart';
import 'package:note_app/features/note/note_bloc.dart';
import 'package:note_app/pages/add_note/add_note_page.dart';
import 'package:note_app/pages/edit/edit_page.dart';
import 'package:note_app/pages/home/home_page.dart';
import 'package:note_app/pages/search/search_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoteBloc(),
        ),
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            name: "addNotePage",
            path: '/addNotePage',
            builder: (context, state) => AddNotePage(),
          ),
          GoRoute(
            name: "searchPage",
            path: '/searchPage',
            builder: (context, state) => SearchPage(),
          ),
          GoRoute(
            name: "editNotePage",
            path: '/editNotePage',
            builder: (context, state) {
              final Note note = state.extra as Note;

              return EditNotePage(note: note);
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
