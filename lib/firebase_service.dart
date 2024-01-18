import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  Stream<DatabaseEvent> dataStream = FirebaseDatabase.instance
      .ref()
      .child('data/display')
      .limitToLast(1)
      .onValue;
}
