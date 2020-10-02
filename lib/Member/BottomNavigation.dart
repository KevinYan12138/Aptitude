import 'package:Aptitude/UI/Articles.dart';
import 'package:Aptitude/UI/Recipes.dart';
import 'package:Aptitude/UI/Schedules.dart';
import 'package:Aptitude/UI/Videos.dart';
import 'package:Aptitude/UI/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/UserRepository.dart';

class BottomNavigation extends StatefulWidget {
  final FirebaseUser user;

  const BottomNavigation({Key key, this.user}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentap = 0;

  SharedPreferences prefs;

  String status;

  Videos videosPage;
  Schedules schedulesPage;
  Recipes recipesPage;
  Articles articlesPage;
  List<Widget> pages;
  Widget currentPage;

  final PageStorageBucket bucket = PageStorageBucket();

  void initState() {
    readLocal();

    videosPage = Videos();
    schedulesPage = Schedules();
    recipesPage = Recipes();
    articlesPage = Articles();
    pages = [videosPage, recipesPage, articlesPage];
    currentPage = videosPage;

    super.initState();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    status = prefs.getString('status') ?? '';

    print(status);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Aptitude",
              style: GoogleFonts.longCang(
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                onPressed: () => status == 'anonymous' ? Provider.of<UserRepository>(context, listen: false).removeUser() : Provider.of<UserRepository>(context, listen: false).signOut())
          ],
          leading: Visibility(
            visible: status == 'anonymous' ? false : true,
            child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }),
          ),
        ),
        body: PageStorage(
          child: currentPage,
          bucket: bucket,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _currentap,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (int _index) {
            setState(() {
              _currentap = _index;
              currentPage = pages[_index];
            });
          },
          items: [
            new BottomNavigationBarItem(icon: new Icon(Icons.video_label_rounded), title: new Text("Videos")),
            //new BottomNavigationBarItem(icon: new Icon(Icons.schedule), title: new Text("Schedules")),
            new BottomNavigationBarItem(icon: new Icon(Icons.receipt), title: new Text("Recipes")),
            new BottomNavigationBarItem(icon: new Icon(Icons.article), title: new Text("Articles")),
          ],
        ));
  }
}
