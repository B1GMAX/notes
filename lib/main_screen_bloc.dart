import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rxdart/rxdart.dart';

class MainScreenBloc {
  final BehaviorSubject<bool> _switchStreamController = BehaviorSubject<bool>();

  Stream<bool> get switchStream => _switchStreamController.stream;

  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot<Object?>> get dataSteram => _notes.snapshots();

  bool _switchToggle = false;

  void toggle() {
    _switchStreamController.add(_switchToggle = !_switchToggle);
  }

  String _deletedTitle = '';
  String _deletedContent = '';

  void deleteNote(String id, String title, String content) {
    _deletedTitle = title;
    _deletedContent = content;
    _notes.doc(id).delete();
  }

  void undoRemove() {
    _notes.add({
      'title': _deletedTitle,
      'content': _deletedContent,
    });
  }

  void dispose() {
    _switchStreamController.close();
  }
}
