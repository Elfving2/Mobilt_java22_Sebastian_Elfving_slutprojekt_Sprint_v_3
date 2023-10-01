import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/UserModel.dart';

UserSingleton user = UserSingleton.instance;

// fix later so i return the instance in the databaseConnection :)
Future<void> addDataToDatabase(String username, String password, String email, String zipcode) async {
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Specify the collection and document where you want to add data
        DocumentReference docRef = firestore.collection('users').doc();
        // Create a Map with the data you want to add
        Map<String, dynamic> data = {
          'username' : username,
          'password' : password,
          'email' : email,
          'zipCode' : zipcode,
          'imageURL' : "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png"
          // Add other fields as needed
        };

        // Use set() to add the data to the document
        await docRef.set(data);

        print('Data added successfully');
      } catch (e) {
      print('Error adding data: $e');
    }
  }


Future login(String username, String password) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query Firestore to find a user with the provided email
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1) // Limit to 1 result (assuming email is unique)
        .get();

    // if username exist go to if statement
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming that there is only one user with the provided email
      final userDocument = querySnapshot.docs.first;
      //final userData = userDocument.data();
      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        // Compare the user-entered password with the stored password in the retrieved user document
        if (userData['password'] == password) {
          print('Login successful');

          //get information
          String email = userData['email'];
          String zipCode = userData['zipCode'];
          String imageURL = userData['imageURL'];

          UserSingleton user = UserSingleton.instance;
          user.setUsername(username);
          user.setPassword(password);
          user.setEmail(email);
          user.setZipcode(zipCode);
          user.setImageURL(imageURL);

        } else {
          print('Incorrect password');
        }
      } else {
        print('User not found');
      }
    }
  } catch (e) {
    print('Error during login: $e');
  }
}

Future changeUserDetails(String newValue , String key, String currentValue) async {
  if (newValue.trim() != "" && newValue.trim() != currentValue) {
    try {
      final fireStore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await fireStore.collection('users').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Check if the 'username' field matches the old username;
        if (data[key] == currentValue) {
          // Update the 'username' field with the new username
          await doc.reference.update({'$key' : newValue});
          print("$key : $currentValue");

          if (key == "username") {
            login(newValue, user.password);
          } else if(key == "password") {
            login(user.username, newValue);
          } else {
            login(user.username, user.password);
          }
          print('Username updated successfully.');
          // You can break the loop here if you want to update only the first match.
        }
      }
    } catch (e) {
      print('Error updating username: $e');
    }
  }
}





// connect to firebaseDatabase



