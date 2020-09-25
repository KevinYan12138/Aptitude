import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeView extends StatefulWidget {

  final String title;
  final String content;

  const RecipeView({Key key, this.title, this.content}) : super(key: key);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children:[ 
            Center(
            child: Container(
              width: size.width * 0.8,
              child: Column(
                children: [
                  SizedBox(height: 60,),
                  Text(widget.content, style: GoogleFonts.openSans(textStyle: TextStyle()))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed:()=> Navigator.pop(context)),
          )
        ]
      ),
    ));
  }
}