import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EditNoteBloc {
  final DocumentSnapshot? docEdit;
  String _title = '';
  String _content = '';
  late AnimationController _animationController;

  final BehaviorSubject<Animation<Offset>> _offsetStreamController =
      BehaviorSubject<Animation<Offset>>();

  Stream<Animation<Offset>> get offsetStream => _offsetStreamController.stream;

  EditNoteBloc({this.docEdit, required TickerProvider tickerProvider}) {
    titleTextController.text = docEdit?['title'] ?? '';
    contentTextController.text = docEdit?['content'] ?? '';
    _title = docEdit?['title'] ?? '';
    _content = docEdit?['content'] ?? '';
    titleTextController.addListener(() {
      _buttonToggleByText();
      showButton();
    });
    contentTextController.addListener(() {
      _buttonToggleByText();
      showButton();
    });
    _animationController = AnimationController(
        vsync: tickerProvider, duration: const Duration(seconds: 1));

    _offsetStreamController.add(Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_animationController));
  }

  void showButton() {
    if (_buttonToggle) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  final TextEditingController titleTextController = TextEditingController();

  final TextEditingController contentTextController = TextEditingController();

  final BehaviorSubject<bool> _switchButtonStreamController =
      BehaviorSubject<bool>();

  Stream<bool> get switchButtonStream => _switchButtonStreamController.stream;

  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');
  bool _buttonToggle = false;

  void showSaveDialog(BuildContext context) {
    _buttonToggle
        ? showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: Dialog(
                    child: SizedBox(
                      height: 150,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Сохранить заметки?'),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    child: const Text('Сохранить и выйти'),
                                    onPressed: () {
                                      updateNote(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    child: const Text('Выйти без сохранения'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) {
              return const SizedBox.shrink();
            })
        : Navigator.of(context).pop();
  }

  void _buttonToggleByText() {
    if (titleTextController.text != _title ||
        contentTextController.text != _content) {
      _buttonToggle = true;
    }
    if (titleTextController.text == _title &&
        contentTextController.text == _content) {
      _buttonToggle = false;
    }
    _switchButtonStreamController.add(_buttonToggle);
  }

  void updateNote(BuildContext context) {
    if (docEdit == null) {
      _notes.add({
        'title': titleTextController.text,
        'content': contentTextController.text,
      });
    } else {
      docEdit?.reference.update({
        'title': titleTextController.text,
        'content': contentTextController.text,
      });
    }
    Navigator.pop(context);
  }

  void dispose() {
    _offsetStreamController.close();
    _switchButtonStreamController.close();
    titleTextController.dispose();
    contentTextController.dispose();
    _animationController.dispose();
  }
}
