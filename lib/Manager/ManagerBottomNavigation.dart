import 'package:Aptitude/UI/Articles.dart';
import 'package:Aptitude/UI/Profile.dart';
import 'package:Aptitude/UI/Recipes.dart';
import 'package:Aptitude/UI/Schedules.dart';
import 'package:Aptitude/UI/Videos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Auth/UserRepository.dart';


class ManagerBottomNavigation extends StatefulWidget {
  final FirebaseUser user;

  const ManagerBottomNavigation({Key key, this.user}) : super(key: key);
  @override
  _ManagerBottomNavigationState createState() => _ManagerBottomNavigationState();
}

class _ManagerBottomNavigationState extends State<ManagerBottomNavigation> {

  int _currentap = 0;

  Videos videosPage;
  Schedules schedulesPage;
  Recipes recipesPage;
  Articles articlesPage;
  List<Widget> pages;
  Widget currentPage;

  void initState() {
    videosPage = Videos();
    schedulesPage = Schedules();
    recipesPage = Recipes();
    articlesPage = Articles();
    pages = [videosPage, recipesPage, articlesPage];
    currentPage = videosPage;
    super.initState();
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Aptitude', style: GoogleFonts.longCang(textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.black,),
              onPressed: () => Provider.of<UserRepository>(context, listen: false).signOut()
          )
        ],
        leading: IconButton(
            icon: Icon(Icons.person, color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            }),
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
        )
    );
  }
}
