import 'package:flutter/material.dart';
import 'package:vit_helper/ui/facultyDetails.dart';

class FacultyScreen extends StatelessWidget {
  final data;
  FacultyScreen(this.data);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(
            child: Text(data[index]['name'].toString()),
          ),
          onTap: () {
            var route = MaterialPageRoute(
              builder: (context) {
                return FacultyDetails(data[index]);
              }
            );

            Navigator.of(context).push(route);
          },
        );
      },
      itemCount: data.length, 
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}