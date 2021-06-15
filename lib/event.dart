import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/login_info.dart';

class ToDoEvents {
  String eventID;
  String title;
  String desc;

  ToDoEvents(this.eventID, {this.title, this.desc});

  factory ToDoEvents.fromJSON(eventID, Map<String, dynamic> json) {
    return ToDoEvents(
      eventID,
      title: json["title"],
      desc: json["desc"],
    );
  }
}

class EventList {
  List<ToDoEvents> get eventList => LoginInfo.toDoEventList;

}

class InheritedEventWidget extends InheritedWidget {
  final Widget child;
  final EventList eventInfo = EventList();

  EventList get eventListInfo => eventInfo;

  InheritedEventWidget({
    Key key,
    this.child,
  }) : super(key: key, child: child);

  static InheritedEventWidget of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedEventWidget>());
  }

  @override
  bool updateShouldNotify(InheritedEventWidget oldWidget) {
    return oldWidget.eventInfo != oldWidget;
  }
}
