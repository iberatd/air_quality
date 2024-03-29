import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService firebaseService = FirebaseService();

  dynamic prevValMap;
  String prevTargetValue = "";

  final features = [
    'Temperature',
    'Humidity',
    'CO2',
    'PM25',
    'PM10',
    'PM1',
    'Voc',
    'MeasuredTime',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Air Quality Application',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: firebaseService.dataStream,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var rawMap =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            var key = rawMap?.keys.first;
            var valueMap = rawMap?[key];
            String targetValue = "";
            if (valueMap.runtimeType == String) {
              targetValue = prevTargetValue;
              valueMap = prevValMap;
            } else {
              prevValMap = valueMap;
              targetValue = valueMap?['Prediction'] ?? 'N/A';
              prevTargetValue = targetValue;
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of columns
                      childAspectRatio: 1.75, // width / height
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Text(
                            features[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Card(
                              child: Center(
                                child: Text(
                                  /*'${valueMap?[features[index]] ?? 'N/A'}',*/
                                  '${((valueMap?[features[index]] ?? 'N/A').toString().split('.').first + "." + (valueMap?[features[index]] ?? 'N/A').toString().split('.').last.substring(0, 1))}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
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
                          const Text(
                            'Air Quality',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: width / 2,
                            height: 64,
                            child: Card(
                              child: Center(
                                child: Text(
                                  targetValue,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
