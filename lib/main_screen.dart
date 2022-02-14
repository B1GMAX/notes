import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_note_screen.dart';
import 'notes_grid_widget.dart';
import 'notes_list_widget.dart';
import 'main_screen_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<MainScreenBloc>(
      create: (BuildContext context) => MainScreenBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      builder: (context, _) {
        return StreamBuilder<bool>(
          stream: context.read<MainScreenBloc>().switchStream,
          initialData: false,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Your Notes'),
                actions: [
                  Switch(
                    value:snapshot.data!,
                    onChanged: (value) {
                      context.read<MainScreenBloc>().toggle();
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const EditNoteScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: context.read<MainScreenBloc>().dataSteram,
                builder: (context,  querySnapshot) {
                  return querySnapshot.hasData
                      ? Stack(
                          children: [
                            IgnorePointer(
                              ignoring: snapshot.data!,
                              child: AnimatedOpacity(
                                opacity: snapshot.data! ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 500),
                                child: NotesGridWidget(
                                  querySnapshot: querySnapshot,
                                ),
                              ),
                            ),
                            IgnorePointer(
                              ignoring: !snapshot.data!,
                              child: AnimatedOpacity(
                                opacity: snapshot.data! ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: NotesListWidget(
                                  querySnapshot: querySnapshot,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),
            );
          },
        );
      },
    );
  }
}
