import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'note_witget.dart';

class NotesListWidget extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> querySnapshot;

  const NotesListWidget({
    Key? key,
    required this.querySnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: querySnapshot.hasData ? querySnapshot.data?.docs.length : 0,
      itemBuilder: (context, index) {
        return NoteWidget(
          index: index,
          querySnapshot: querySnapshot,
        );
      },
    );
  }
}
