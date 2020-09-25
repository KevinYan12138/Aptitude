import 'package:Aptitude/UI/AddSchedules.dart';
import 'package:flutter/material.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      floatingActionButton: Container(
        child: Visibility(
          //visible: status.toString() == 'member' ? false : true,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddSchedules())),
            child: Icon(Icons.add),
          ),
        ),
      ),
      
    );
  }
}