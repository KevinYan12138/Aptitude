import 'package:Aptitude/Manager/AddArticles.dart';
import 'package:Aptitude/UI/RecipeView.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
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
          stream: Firestore.instance.collection('articles').snapshots(),
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
                                        builder: (context) => RecipeView(
                                              title: document['title'],
                                              content: document['content'],
                                            )));
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: Card(
                                    color: Colors.white,
                                    child: SizedBox(
                                      height: 150,
                                      width: size.width * 0.95,
                                      child: Center(
                                          child: AutoSizeText(
                                        document['title'],
                                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
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
                                      builder: (context) => RecipeView(
                                            title: document['title'],
                                            content: document['content'],
                                          )));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
                                    height: 150,
                                    width: size.width * 0.95,
                                    child: Center(
                                        child: Text(
                                      document['title'],
                                      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                      textAlign: TextAlign.center,
                                    )),
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
          visible: status.toString() == 'admin' ? true : false,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddArticles())),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
