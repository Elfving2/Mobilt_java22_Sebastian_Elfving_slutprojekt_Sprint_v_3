import 'package:flutter/material.dart';
import 'package:slutprojekt_flutter1/database/databaseConnection.dart';
import 'MainSite.dart';
import 'model/UserModel.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    // Other configurations for your app
  ));
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  String usernameValue = "";
  String passwordValue = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    usernameController.addListener(() {
      setState(() {
        usernameValue = usernameController.text;
      });
    });

    passwordController.addListener(() {
      setState(() {
        passwordValue = passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget usernameWidget = getSizedBoxWidget("User Name", false, usernameController, usernameValue);
    Widget passwordWidget = getSizedBoxWidget("Password", true, passwordController, passwordValue);

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
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            usernameWidget,
            const SizedBox(height: 16.0),
            passwordWidget,
            TextButton(
              onPressed: () {
                checkLogin(usernameValue, passwordValue);
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLogin(username, password) async {
    await login(username, password);
    UserSingleton user = UserSingleton.instance;

    if (user.username == "" && user.password == "") {
      // Handle login failure
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Run(),
        ),
      );
    }
  }
}

Widget getSizedBoxWidget(String typeOf, bool isPassword, TextEditingController controller, String input) {
  return SizedBox(
    width: 250,
    height: 60,
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: typeOf,
      ),
    ),
  );
}