import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id;

  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String _id;

  _EditContactState(this._id);

  String _firstName = "";
  String _lastName = "";
  String _address = "";
  String _email = "";
  String _phone = "";
  String _photoUrl;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool isLoading = true;

  // firebase helper

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    //get contact from firebase
    this.getContact(_id);
  }

  getContact(id) async {
    Contact contact;
    _databaseReference.child(id).onValue.listen((event) {
      contact = Contact.fromSnapshot(event.snapshot);

      _fnController.text = contact.firstName;
      _lnController.text = contact.lastName;
      _addressController.text = contact.address;
      _emailController.text = contact.email;
      _phoneController.text = contact.phone;

      setState(() {
        _firstName = contact.firstName;
        _lastName = contact.lastName;
        _email = contact.email;
        _address = contact.address;
        _phone = contact.phone;
        _photoUrl = contact.photoUrl;

        isLoading = false;
      });
    });
  }

  updateContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact = Contact.withId(
          this._id,
          this._firstName,
          this._lastName,
          this._address,
          this._email,
          this._phone,
          this._photoUrl);
      await _databaseReference.child(_id).set(contact.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Field Required'),
              content: Text('All fields are required'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    }
  }

  //pick image
  Future pickImage() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    String filename = basename(file.path);
    uploadImage(file, filename);
  }

  //upload image

  void uploadImage(File file, String fileName) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("assets/logo.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),

                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                    ),
                    // update button
                    ElevatedButton(
                      onPressed: () {
                        updateContact(context);
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
