import 'package:flutter/material.dart';
import 'package:vit_helper/search/customSearchDelegate.dart';
import 'package:vit_helper/ui/facultyScreen.dart';
import 'package:vit_helper/ui/paperScreen.dart';

class Home extends StatefulWidget {
  final data;

  Home(this.data);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _homeScreen(context, widget.data, _tabController);
  }
}



Widget _homeScreen(context, data, controller) {
  return Scaffold(
      appBar: AppBar(
        title: Text('VIT Helper'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(54, 64, 81, 1),
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              child: Text("Teachers"),
            ),
            Tab(
              child: Text("Papers")
            )
          ],
        ),
      ),

      body: TabBarView(
        controller: controller,
        children: <Widget>[
          FacultyScreen(data),
          PaperScreen()
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Color.fromRGBO(97, 117, 158, 1),
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(data)
          );
        },
      ),
    );
}







      