import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_note_screen.dart';
import 'main_screen_bloc.dart';

class NoteWidget extends StatelessWidget {
  final int index;
  final AsyncSnapshot<QuerySnapshot> querySnapshot;

  const NoteWidget({Key? key, required this.index, required this.querySnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (d) {
        bloc.deleteNote(
          querySnapshot.data!.docs[index].id,
          querySnapshot.data!.docs[index]['title'],
          querySnapshot.data!.docs[index]['content'],
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item dismissed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                bloc.undoRemove();
              },
            ),
          ),
        );
      },
      key: ValueKey(querySnapshot.data!),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => EditNoteScreen(
                docEdit: querySnapshot.data!.docs[index],
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.grey[300],
          child: Column(
            children: [
              Text(querySnapshot.data?.docs[index]['title']),
              const SizedBox(
                height: 20,
              ),
              Text(
                querySnapshot.data?.docs[index]['content'],
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
