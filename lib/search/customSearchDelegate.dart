import 'package:flutter/material.dart';
import 'package:vit_helper/ui/facultyDetails.dart';

class CustomSearchDelegate extends SearchDelegate {
  final data;

  CustomSearchDelegate(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    final results = data.where((p) => p['name'].toString().toLowerCase().startsWith(query.toLowerCase())).toList();

    return _buildItems(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedData = query.isEmpty 
      ? data 
      : data.where((p) => p['name'].toString().toLowerCase().startsWith(query.toLowerCase())).toList();

    return _buildItems(suggestedData);
  }

  _buildItems(list) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(
            child: RichText(
                text: TextSpan(
                    text: list[index]['name'].toString().substring(0, query.length),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: list[index]['name'].toString().substring(query.length),
                        style: TextStyle(color: Colors.grey),
                      )
                    ]
                  ),
              ),
          ),
          onTap: () {
            var route = MaterialPageRoute(
              builder: (context) {
                return FacultyDetails(list[index]);
              }
            );

            Navigator.of(context).push(route);
          },
        );
      },
      itemCount: list.length, 
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

}