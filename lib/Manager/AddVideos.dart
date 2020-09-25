import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVideos extends StatefulWidget {
  @override
  _AddVideosState createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String title = '';
  String videoId = '';
  String photoUrl = '';
  File coverImage;
  bool isLoading = false;
  final picker = ImagePicker();

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  } 

  Future<void> handleUpdateData() async{

    Firestore.instance.collection('videos').document(title).setData({
      //'image': photoUrl,
      'title': title,
      'videoId': videoId,
    }).then((data) async {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Posted successfully"),));
      Future.delayed(new Duration(seconds: 3)).then((value) => Navigator.pop(context));

    }).catchError((err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.toString()),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Video'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
            child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: size.width * 0.8,
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Title' ,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.circular(5),
                        ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))
                        ),
                        validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
                        onSaved: (value) => title = value,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 150,
                      width: size.width * 0.8,
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Video Id',
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.circular(5),
                        ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        validator: (value) => value.isEmpty ? 'Video Id can\'t be empty' : null,
                        onSaved: (value) => videoId = value,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 40,
                      width: size.width * 0.8,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.white)),
                        child: Text('Post'),
                        onPressed: ()async{
                          if(_validateAndSave()){
                              handleUpdateData();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              )
        ),
      ),
    );
  }
}