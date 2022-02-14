import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_note_bloc.dart';

class EditNoteScreen extends StatefulWidget {
  final DocumentSnapshot? docEdit;

  const EditNoteScreen({
    Key? key,
    this.docEdit,
  }) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<EditNoteBloc>(
      create: (BuildContext context) =>
          EditNoteBloc(docEdit: widget.docEdit, tickerProvider: this),
      dispose: (context, bloc) => bloc.dispose(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                context.read<EditNoteBloc>().showSaveDialog(context);
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller:
                          context.read<EditNoteBloc>().titleTextController,
                    ),
                    height: 100,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller:
                            context.read<EditNoteBloc>().contentTextController,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StreamBuilder<Animation<Offset>>(
                  stream: context.read<EditNoteBloc>().offsetStream,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? SlideTransition(
                            position: snapshot.data!,
                            child: StreamBuilder<bool>(
                                stream: context
                                    .read<EditNoteBloc>()
                                    .switchButtonStream,
                                initialData: false,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<EditNoteBloc>()
                                            .updateNote(context);
                                      },
                                      child: const Text('save'),
                                    ),
                                  );
                                }),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
