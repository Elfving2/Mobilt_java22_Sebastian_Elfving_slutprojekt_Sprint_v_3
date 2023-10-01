import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database/databaseConnection.dart';

void main() {
  runApp(Register());
}
class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Register> {
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
          body: Container(
          padding: const EdgeInsets.all(20),
          child: StepperExample(input: "hej"),
        ),
    );
    }
  }

class StepperExample extends StatefulWidget {
  const StepperExample({super.key, required this.input});
  final String input;

  @override
  State<StepperExample> createState() => _StepperExampleState();
}



// instead have to controllers the "current fields"
class _StepperExampleState extends State<StepperExample> {
  int _Activeindex = 0;
  String usernameValue = "";
  String passwordValue = "";
  String emailValue = "";
  String zipCodeValue = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget usernameWidget = getSizedBoxWidget("User Name", false, usernameController, usernameValue);
    Widget passwordWidget = getSizedBoxWidget("Password", true, passwordController, passwordValue);
    Widget emailWidget = getSizedBoxWidget("Email", false, emailController, emailValue);
    Widget zipCodeWidget = getSizedBoxWidget("Zip Code", false, zipCodeController, zipCodeValue);

    return Stepper(
      currentStep: _Activeindex,
      onStepTapped: (int index) {
        setState(() {
          _Activeindex = index;
        });
      },
      controlsBuilder: (context,_) {
        return Row(
          children: <Widget>[
            TextButton(onPressed: () {
              if (_Activeindex == 2) {
                if (usernameValue != "" && passwordValue != "" && emailValue != "" && zipCodeValue != "") {
                  addDataToDatabase(usernameValue, passwordValue, emailValue, zipCodeValue);
                  print('User was created!');
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text("User $usernameValue was created!"),
                      duration: const Duration(seconds: 2), // Duration for how long the message is displayed
                    )
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You have to fill in all fields!"),
                      duration: Duration(seconds: 2), // Duration for how long the message is displayed
                    )
                  );
                }
              } else {
                _handleStepContinue();
              }
            },
                child: Text("continue")
            ),
            TextButton(
              onPressed: (){
                _handleStepCancel();
              },
              child: const Text('Back'),
            ),
          ],
        );
      },
      steps: <Step>[
        Step(
          state: _Activeindex <= 0?StepState.editing : StepState.complete,
          isActive: _Activeindex >= 0,
          title: const Text('Username and Password'),
          content: Container(
            padding : const EdgeInsets.all(2),
            alignment: Alignment.centerLeft,
            child : Column(
              children: [
                usernameWidget,
                const SizedBox(height: 16.0),
                passwordWidget,
              ],
            )
          ),
        ),
        Step(
          state: _Activeindex <= 1 ? StepState.editing : StepState.complete,
          isActive: _Activeindex >= 1,
          title: const Text('Email and ZIP code'),
          content:Container(
            padding : const EdgeInsets.all(2),
            alignment: Alignment.centerLeft,
            child : Column(
              children: [
                emailWidget,
              const SizedBox(height: 16.0),
              zipCodeWidget
              ]
            )
          ),
        ),
        Step(
          state: _Activeindex <= 2 ?StepState.editing : StepState.complete,
          isActive: _Activeindex >= 2,
          title: const Text('Step 3 title'),
          content: Container(
            child : displayUserInformation(usernameController, passwordController, emailController, zipCodeController),
          )
        )
      ],
    );
  }

  void _handleStepCancel() {
    if (_Activeindex > 0) {
      setState(() {
        _Activeindex -= 1;
      });
    }
  }

  void _handleStepContinue() {
    if (_Activeindex < 2) {
      setState(() {
        _Activeindex += 1;
      });
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
          labelText : typeOf,
        ),
      ),
    );
  }

  Widget validateButton() {
    return ElevatedButton (
      onPressed: () {
        if (usernameValue == "" || passwordValue == "" || emailValue == "" || zipCodeValue == "") {
          print('you have to enter a valid username and password');
          print(usernameValue);
          print(passwordValue);
        } else {
          setState(() {
            // usernameValue = usernameController.text;
            // passwordValue = passwordController.text;
            // emailValue = emailController.text;
            // zipCodeValue = zipCodeController.text;
            // displayUserInformation(usernameValue,passwordValue,emailValue,zipCodeValue);
          });
        }
      },
      style: ElevatedButton.styleFrom (
          minimumSize: Size(100, 25),
          textStyle: TextStyle(fontSize: 20),
          backgroundColor: Colors.red,
          shape : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      child: Text ("Login"),
    );
  }

  Widget displayUserInformation(TextEditingController userController, TextEditingController passwordController, TextEditingController emailController, TextEditingController zipCodeController,) {
    usernameValue = userController.text;
    passwordValue = passwordController.text;
    emailValue = emailController.text;
    zipCodeValue = zipCodeController.text;

    return Column(
        children :  [
          Text("User Name: $usernameValue"),
          Text("Password: $passwordValue"),
          Text("Email: $emailValue"),
          Text("Zip Code: $zipCodeValue")
        ],
    );
  }
}

