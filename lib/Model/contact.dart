import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id;
  String _firstName;
  String _lastName;
  String _address;
  String _phone;
  String _email;
  String _photoUrl;

  //constructor for adding
  Contact(this._firstName, this._lastName, this._address, this._email,
      this._phone, this._photoUrl);

//Constructor for editing
  Contact.withId(this._id, this._firstName, this._lastName, this._address,
      this._email, this._phone, this._photoUrl);

  //getters
  String get id => this._id;

  String get firstName => this._firstName;

  String get lastName => this._lastName;

  String get email => this._email;

  String get address => this._address;

  String get phone => this._phone;

  String get photoUrl => this._photoUrl;

//setters

  set firstName(String firstName) {
    this._firstName = firstName;
  }

  set lastName(String lastName) {
    this._lastName = lastName;
  }

  set email(String email) {
    this._email = email;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set address(String address) {
    this._address = address;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  Contact.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._phone = snapshot.value['phone'];
    this._photoUrl = snapshot.value['photoUrl'];
  }

  //convert into json object

  Map<String, dynamic> toJson() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl
    };
  }
}
