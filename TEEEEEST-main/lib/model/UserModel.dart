class UserSingleton {
  String username;
  String password;
  String email;
  String zipcode;
  String imageURL;

  // Privat konstruktor för att förhindra att flera instanser skapas
  UserSingleton._privateConstructor({
    required this.username,
    required this.password,
    required this.email,
    required this.zipcode,
    required this.imageURL,
  });

  // Den enda instansen av klassen
  static final UserSingleton _instance = UserSingleton._privateConstructor(
    username: '',
    password: '',
    email: '',
    zipcode: '',
    imageURL: '',
  );

  // Getter för att hämta instansen
  static UserSingleton get instance => _instance;

  // Setter-metoder för att ändra individuella värden
  void setUsername(String newUsername) {
    username = newUsername;
  }

  void setPassword(String newPassword) {
    password = newPassword;
  }

  void setEmail(String newEmail) {
    email = newEmail;
  }

  void setZipcode(String newZipcode) {
    zipcode = newZipcode;
  }

  void setImageURL(String newImageURL) {
    imageURL = newImageURL;
  }

  void logout() {
    username = '';
    password =  '';
    email =  '';
    zipcode = '';
    imageURL = '';
  }
}
