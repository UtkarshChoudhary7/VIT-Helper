import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vit_helper/ui/home.dart';

class SplashScreen extends StatelessWidget {
  final _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    _database.reference().child("FacultyData").once().then((snapshot) {
      snapshot.value.sort((a, b) {
        return a['name'].toLowerCase().toString().compareTo(b['name'].toLowerCase().toString());
      });

      

      var route = MaterialPageRoute(builder: (context) {
        return Home(snapshot.value);
      });

      Navigator.of(context).pushReplacement(route);
    });

    return _loadingScreen(context);
  }

  
}

Widget _loadingScreen(context) {
  return Scaffold(
    body: Container(
      color: Color.fromRGBO(54, 64, 81, 1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white10,
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            Padding(padding: EdgeInsets.all(8.0),),
            Text(
              "Getting Data",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w300
              ),
            )
          ],
        ),
      ),
    ),
  );
}