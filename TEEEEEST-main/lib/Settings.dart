import 'package:flutter/material.dart';
import 'package:slutprojekt_flutter1/model/UserModel.dart';
import 'Login.dart';
import 'database/databaseConnection.dart';

const String settingsRoute = '/settings';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
              // Navigator.of(context).push(MaterialPageRoute(
              // builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ProfileEditor(),
      ),
    );
  }
}

class ProfileEditor extends StatefulWidget {
  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  UserSingleton user = UserSingleton.instance;
  bool showPassword = false;
  int _selectedIndex = 0;
  String usernameValue = "";
  String passwordValue = "";
  String emailValue = "";
  String zipCodeValue = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set up the listener for the usernameController
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

    emailController.addListener(() {
      setState(() {
        emailValue = emailController.text;
      });
    });

    zipCodeController.addListener(() {
      setState(() {
        zipCodeValue = zipCodeController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 10),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          user.imageURL,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            buildTextField("username", user.username, false, usernameController),
            buildTextField("Password", hiddenPassword(user.password), true, passwordController),
            buildTextField("E-mail", user.email, false, emailController),
            buildTextField("Zip Code", user.zipcode, false, zipCodeController),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Add your button's action here
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Button actions
                    changeUserDetails(usernameValue, "username", user.username);
                    changeUserDetails(passwordValue, "password", user.password);
                    changeUserDetails(emailValue, "email", user.email);
                    changeUserDetails(zipCodeValue, "zipCode", user.zipcode);

                    usernameController.text = "";
                    passwordController.text = "";
                    emailController.text = "";
                    zipCodeController.text = "";

                    setState(() {
                      changeUserDetails(usernameValue, "username", user.username);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Background color
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
    // Use Navigator to navigate to different screens based on the index
    switch (index) {
      case 0:
        user.logout();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()), // Instantiate Login
        );
        break;
      case 1:
      //Navigator.push(context, MaterialPageRoute(builder: (context) => MainSite())); // Navigate to MainSite
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings()), // Instantiate Settings
        );
        break;
    }
  }

  String hiddenPassword(String password) {
    List<String> stringList = [];

    for (int i = 0; i < password.length; i++) {
      stringList.add("*");
    }
    String result = stringList.join();
    return result;
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        onChanged: (newValue) {
          setState(() {
            // force update the user object value to the input of the textField unless it's empty
            if (usernameValue != "") {
              user.username = usernameValue;
            }
            if (passwordValue != "") {
              user.password = passwordValue;
            }

            if (emailValue != "") {
              user.email = emailValue;
            }

            if (zipCodeValue != "") {
              user.zipcode = zipCodeValue;
            }
          });
        },
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: const Icon(
              Icons.remove_red_eye,
              color: Colors.grey,
            ),
          )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
