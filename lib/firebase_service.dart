import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  Stream<DatabaseEvent> dataStream = FirebaseDatabase.instance
      .ref()
      .child('data/upload')
      .limitToLast(1)
      .onValue;
}
