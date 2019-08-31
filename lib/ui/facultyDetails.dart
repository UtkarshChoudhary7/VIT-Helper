import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class FacultyDetails extends StatefulWidget {
  final data;

  FacultyDetails(this.data);

  @override
  _FacultyDetailsState createState() => _FacultyDetailsState();
}

class _FacultyDetailsState extends State<FacultyDetails> {
  var _storageRef;
  var url;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _storageRef = FirebaseStorage.instance
        .ref()
        .child(widget.data['id'].toString() + '.jpg');
    getImage();
  }

  getImage() async {
    url = await _storageRef.getDownloadURL();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(104, 128, 120, 1),
        appBar: AppBar(
          title: Text('Faculty Details'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(104, 128, 120, 1),
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            _infoCard(context, widget),
            _pic(loading, url),
            CustomBottomSheet(widget.data['comments'])
          ],
        ));
  }
}

_pic(loading, url) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Container(
        height: 150.0,
        width: 150.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
            // border: Border.all(
            //   width: 2.0,
            //   color: Colors.black
            // ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5.0)
            ]),
        child: loading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white10,
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(97, 117, 158, 1)),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(url.toString()),
                backgroundColor: Colors.white,
              ),
      ),
    ),
  );
}

_infoCard(context, widget) {
  return Positioned(
    height: MediaQuery.of(context).size.height / 1.6,
    width: MediaQuery.of(context).size.width - 20,
    left: 10,
    top: MediaQuery.of(context).size.height * 0.15,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 70.0,
          ),
          ListTile(
            title: Center(
                child: Text(
              widget.data['name'],
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
            subtitle: Center(child: Text(widget.data['designation'])),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text(widget.data['school']),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border),
            title: Text(widget.data['room']),
          ),
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text(widget.data['phone']),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(widget.data['mail']),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () => _makeCall(widget.data['phone'].toString()),
                  color: Color.fromRGBO(97, 117, 158, 1),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () => _composeMail(widget.data['mail'].toString()),
                  color: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(
                          color: Color.fromRGBO(97, 117, 158, 1), width: 1.8)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.mail,
                    color: Color.fromRGBO(97, 117, 158, 1),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    ),
  );
}

_makeCall(number) async {
  var url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_composeMail(to) async {
  var url = 'mailto:$to';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class CustomBottomSheet extends StatefulWidget {
  final data;
  CustomBottomSheet(this.data);
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> with SingleTickerProviderStateMixin{

  double sheetTop = 700;
  double minSheetTop = 300;

  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    animation = 
      Tween(begin: sheetTop, end: minSheetTop).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut
        )
      )
        ..addListener(() {setState(() {});});
  }
  
  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? controller.reverse() : controller.forward();
        },
        onVerticalDragEnd: (dragEndDetails) {
          if(dragEndDetails.primaryVelocity < 0.0) {
            controller.forward();
          } else if(dragEndDetails.primaryVelocity > 0.0) {
            controller.reverse();
          } else {
            return;
          }
        },
        child: SheetContainer(widget.data),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  final data;
  SheetContainer(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5.0)
            ]
        ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 25),
            height: 3,
            width: 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xffd9dbdb)),
          ),
          Center(
            child: Text("Reviews"),
          ),
          data == null || data.length == 0
              ? Center(
                  child: Text("No Reviews Found"),
                )
              : Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      debugPrint(data.toString());
                      return ListTile(
                        leading: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(data[index]),
                      );
                    },
                    itemCount: data.length,
                  ),
                )
        ],
      ),
    );
  }
}
