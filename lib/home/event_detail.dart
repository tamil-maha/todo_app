import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:todo/event.dart';

class EventDetailPage extends StatefulWidget {
  var index;

  EventDetailPage({this.index});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    var eventDetail = Provider.of<EventList>(context).events[widget.index];
    //var eventDetail = InheritedEventWidget.of(context).eventInfo.events[widget.index];
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                eventDetail.title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Description',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                eventDetail.desc,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
