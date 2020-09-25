import 'package:Aptitude/Manager/AddVideos.dart';
import 'package:Aptitude/UI/VideoView.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  SharedPreferences preferences;

  String status = '';

  @override
  void initState() {
    readLocal();
    super.initState();
  }

  void readLocal() async {
    preferences = await SharedPreferences.getInstance();
    status = preferences.getString('status');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('videos').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: new CircularProgressIndicator());
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return status.toString() == 'admin'
                        ? Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(color: Colors.red),
                            key: ObjectKey(document),
                            onDismissed: (direction) {
                              setState(() {
                                document.reference.delete();
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoView(
                                              videoId: document['videoId'],
                                            )));
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: Card(
                                    color: Colors.white,
                                    child: Container(
                                      height: 125,
                                      width: size.width * 0.95,
                                      child: Center(
                                          child: AutoSizeText(
                                        document['title'],
                                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoView(
                                            videoId: document['link'],
                                          )));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
                                    height: 125,
                                    width: size.width * 0.95,
                                    child: Center(child: Text(document['title'], style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)))),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }).toList(),
                );
            }
          }),
      floatingActionButton: Container(
        child: Visibility(
          visible: status.toString() == 'member' ? false : true,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddVideos())),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
