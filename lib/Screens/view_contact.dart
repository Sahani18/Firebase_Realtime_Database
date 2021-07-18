import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_contact.dart';
import '../Model/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  final String id;

  ViewContact(this.id);

  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  String id;
  Contact contact;
  bool isLoading = true;

  _ViewContactState(this.id);

  getContact(id) async {
    databaseReference.child(id).onValue.listen((event) {
      setState(() {
        contact = Contact.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call $number';
    }
  }

  smsAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send sms to $number';
    }
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  navigateToEditScreen(id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditContact(id)));
  }

  deleteContact() {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure to delete ?'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await databaseReference.child(id).remove();
                    navigateToLastScreen();
                  },
                  child: Text(
                    'Delete',
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                  ))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  Container(
                      height: 200.0,
                      child: Image(
                        image: contact.photoUrl == "empty"
                            ? AssetImage("assets/logo.png")
                            : NetworkImage(contact.photoUrl),
                        fit: BoxFit.contain,
                      )),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Card(
                    color: Colors.green.shade100,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "${contact.firstName}  ${contact.lastName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),

                  Card(
                    color: Colors.green.shade100,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              contact.phone,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),

                  Card(
                    color: Colors.green.shade100,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              contact.email,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),

                  Card(
                    color: Colors.green.shade100,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              contact.address,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),

                  // call and sms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade900.withOpacity(0.6),
                            Colors.pink.shade900.withOpacity(0.6)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            callAction(contact.phone);
                          },
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade900.withOpacity(0.6),
                            Colors.pink.shade900.withOpacity(0.6)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            smsAction(contact.phone);
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  // edit and delete
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade900.withOpacity(0.6),
                            Colors.pink.shade900.withOpacity(0.6)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            navigateToEditScreen(id);
                          },
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade900.withOpacity(0.6),
                            Colors.pink.shade900.withOpacity(0.6)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            deleteContact();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
