import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'Register.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCjj21p_2A39bSnZznQySJtWgJVn_Ik_AE",
      appId: "1:106046771783:android:b1c87b581cebe21f175762",
      messagingSenderId: "106046771783",
      projectId: "slutprojektflutter-31ec2",
      databaseURL: "https://slutprojektflutter-31ec2-default-rtdb.europe-west1.firebasedatabase.app",
    ),
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              };
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
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton (
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom (
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.lime,
                      shape : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  child: const Text ("Login"),
                ),

                //  spacing between children
                const SizedBox(height: 16.0),
                ElevatedButton (
                  onPressed: () {
                    register();
                  },
                  style: ElevatedButton.styleFrom (
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.lime,
                      shape : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  child: const Text("Register"),
                )
              ],
          )
        )
      );
    }

  void register() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Register()
      )
    );
  }


  void login() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );
  }
}