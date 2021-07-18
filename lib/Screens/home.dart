import 'package:flutter/material.dart';
import 'add_contact.dart';
import 'view_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => AddContact()));
  }

  navigateToViewScreen(id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => ViewContact(id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return GestureDetector(
              onTap: () {
                navigateToViewScreen(snapshot.key);
              },
              child: Card(
                color: Colors.green.shade100,
                elevation: 8,
                shadowColor: Colors.yellow.shade900,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: snapshot.value['photoUrl'] == "empty"
                                  ? AssetImage("assets/logo.png")
                                  : NetworkImage(snapshot.value['photoUrl'])),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                              "${snapshot.value['phone']}",
                              style: TextStyle(fontSize: 16),
                            ),
                            // Padding(padding: EdgeInsets.only(top: 8)),
                            // Text(
                            //   "${snapshot.value['email']}",
                            //   style: TextStyle(fontSize: 16),),
                            // Padding(padding: EdgeInsets.only(top: 8)),
                            // Text(
                            //   "${snapshot.value['address']}",
                            //   style: TextStyle(fontSize: 16),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddScreen,
      ),
    );
  }
}
