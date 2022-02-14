import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'note_witget.dart';

class GridWidget extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> querySnapshot;

  const GridWidget({
    Key? key,
    required this.querySnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: querySnapshot.hasData ? querySnapshot.data?.docs.length : 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (_, index) {
        return NoteWidget(
          index: index,
          querySnapshot: querySnapshot,
        );
      },
    );
  }
}
