import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/login_info.dart';
import 'package:get_it/get_it.dart';

class ToDoEvents {
  String eventID;
  String title;
  String desc;
  Timestamp date;
  bool isChecked;

  ToDoEvents(this.eventID, {this.title, this.desc, this.date, this.isChecked});

  factory ToDoEvents.fromJSON(eventID, Map<String, dynamic> json) {
    return ToDoEvents(
      eventID,
      title: json["title"],
      desc: json["desc"],
      date: json["date"],
      isChecked: json["is_checked"],
    );
  }
}

class EventList extends StatefulWidget {
  List<ToDoEvents> events;

  EventList({this.events});

  // static EventListState of(BuildContext context) {
  //   return (context.dependOnInheritedWidgetOfExactType<InheritedEventWidget>()
  //   as InheritedEventWidget).eventListInfo;
  // }
  static EventListState instance;

  @override
  EventListState createState() {
    instance = EventListState();
    return instance;
  }
}

class EventListState extends State<EventList> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.events = LoginInfo.toDoEventList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class InheritedEventWidget extends InheritedWidget {
//   final Widget child;
//   final EventListState eventInfo = EventListState(events: LoginInfo.toDoEventList,);
//
//   EventListState get eventListInfo => eventInfo;
//
//   InheritedEventWidget({
//     Key key,
//     this.child,
//   }) : super(key: key, child: child);
//
//   static InheritedEventWidget of(BuildContext context) {
//     return (context.dependOnInheritedWidgetOfExactType<InheritedEventWidget>());
//   }
//
//   @override
//   bool updateShouldNotify(InheritedEventWidget oldWidget) {
//     return oldWidget.eventInfo.events != oldWidget;
//   }
// }

//GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerFactory(() => EventListState(events: LoginInfo.toDoEventList));
  //locator.registerSingleton<EventListState>(EventListState(events: LoginInfo.toDoEventList));
}
