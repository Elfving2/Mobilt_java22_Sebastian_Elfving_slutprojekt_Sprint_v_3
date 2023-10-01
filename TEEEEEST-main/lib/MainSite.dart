import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slutprojekt_flutter1/model/UserModel.dart';
import 'Login.dart';
import 'Settings.dart';

class Run extends StatefulWidget {
  Run({super.key});
  @override
  _RunState createState() => _RunState();
}

//
class _RunState extends State<Run> {
  UserSingleton user = UserSingleton.instance;
  int _selectedIndex = 0;
  final auth = FirebaseAuth.instance;
  late DatabaseReference starCountRef;
  final StreamController<DataSnapshot> _controller = StreamController<DataSnapshot>();

  Stream<DataSnapshot> get eventStream => _controller.stream;

  @override
  void initState() {
    super.initState();
    fetchData();
    print("--------------------------------");
  }

  Future<void> fetchData() async {
    try {
      starCountRef = FirebaseDatabase.instance.ref().child("products");
      starCountRef.onValue.listen((event) {
        _controller.add(event.snapshot); // Access snapshot here
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Map<String, dynamic> convertMap(Map<Object?, Object?> inputMap) {
    Map<String, dynamic> outputMap = {};

    inputMap.forEach((key, value) {
      if (key is String) {
        // Convert the key to String and add it to the output map
        outputMap[key] = value;
      }
    });

    return outputMap;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize your app's theme
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.green,
              ),
              onPressed: () {
              },
            ),
          ],
        ),
        body: StreamBuilder<DataSnapshot>(
          stream: eventStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DataSnapshot dataSnapshot = snapshot.data!;
              final dynamic rawData = dataSnapshot.value;

              if (rawData != null) {
                if (rawData is List) {
                  // Handle the case where rawData is a list
                  List<Map<String, dynamic>> productListData = [];

                  for (var item in rawData) {
                    if (item is Map<Object?, Object?>) {
                      Map<String, dynamic> convertedItem = convertMap(item);
                      productListData.add(convertedItem);
                    }
                  }
                  return GridView.extent(
                    maxCrossAxisExtent: 200.0,
                    padding: const EdgeInsets.all(10.0),
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: productListData.map((productData) {
                      String imageURL = productData["image"];
                      String title = productData["title"];
                      var price = productData["price"];

                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Container(
                          width: 200.0,
                          height: 300.0,
                          padding: EdgeInsets.all(2),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageURL,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text("$price\$"),
                                ElevatedButton(
                                  onPressed: () {
                                    print('Button pressed ...');
                                  },
                                  child: const Text('Add To Cart'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Text("Data is not in the expected format (not a list)");
                }
              } else {
                return const CircularProgressIndicator();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        user.logout();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Run(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        );
    }
  }
}
