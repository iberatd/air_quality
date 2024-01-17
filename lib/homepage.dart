import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality Application',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: StreamBuilder<DatabaseEvent>(
              stream: firebaseService.dataStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of columns
                      childAspectRatio: 1.75, // width / height
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Text('Label ${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Card(
                              child: Center(
                                /*child: Text('Value ${map.values.elementAt(index)}'),*/
                                child: Text('Value ${index}'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height / 3,
              color: Colors.lightGreenAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Air Quality',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: width / 2,
                      height: 64,
                      child: Card(
                        child: Center(
                            child: Text('Check',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
