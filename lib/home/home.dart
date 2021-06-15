import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/event.dart';
import 'package:todo/home/event_detail.dart';
import 'package:todo/loader.dart';
import 'package:todo/login_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static _HomePageState instance;

  @override
  _HomePageState createState() {
    instance = _HomePageState();
    return instance;
  }
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool checkedValue = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final updateEventList = Provider.of<EventListState>(this.context);
    //
    // updateEventList.updateList();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // locator<EventListState>().updateList();
      //Provider.of<EventListState>(context).updateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //InheritedEventWidget.of(context).eventListInfo.updateList();
    //Provider.of<EventListState>(context).updateList();
    var totalEvents = Provider.of<EventList>(context, listen: false);
    //var totalEvents = InheritedEventWidget.of(context).eventListInfo;
    return Loader(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text('ToDo List'),
            centerTitle: true,
            elevation: 10,
            leading: Container(),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => CreateEvent()));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: totalEvents.events.length > 0
              ? Container(
                  child: ListView.builder(
                      itemCount: totalEvents.events.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => EventDetailPage(
                                      index: index,
                                    )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10, right: 10, left: 10, bottom: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.teal.shade100),
                              color: Colors.teal.shade50,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: totalEvents.events[index].isChecked,
                                  onChanged: (newValue) async {
                                    totalEvents.events[index].isChecked =
                                        newValue;
                                    setState(() {});
                                    await FirebaseFirestore.instance
                                        .collection('customers')
                                        .doc(LoginInfo.customerDocID)
                                        .collection('to_do_events')
                                        .doc(totalEvents.events[index].eventID)
                                        .update({'is_checked': newValue}).then(
                                            (value) => null);
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    totalEvents.events[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),

                          ),
                        );
                      }),
                )
              : Center(
                  child: Text('Add Events'),
                ),
        ));
  }
}

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  FocusNode descNode = new FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text('Add event'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () async {
              DocumentReference docRef;
              CollectionReference eventRef = await FirebaseFirestore.instance
                  .collection('customers')
                  .doc(LoginInfo.customerDocID)
                  .collection("to_do_events");
              Map<String, dynamic> dataToInsert = new Map();
              dataToInsert['title'] = titleController.text.trim();
              dataToInsert['desc'] = descController.text.trim();
              dataToInsert['date'] = Timestamp.now();
              dataToInsert['is_checked'] = false;
              isLoading = true;
              setState(() {});
              docRef = await eventRef.add(dataToInsert);
              setState(() {
                isLoading = false;
                titleController.text = '';
                descController.text = '';
                LoginInfo.toDoEventList
                    .add(new ToDoEvents.fromJSON(docRef.id, dataToInsert));
                if (LoginInfo.toDoEventList.length > 0) {
                  LoginInfo.toDoEventList
                      .sort((a, b) => a.date.compareTo(b.date));
                }
                if (HomePage.instance != null && HomePage.instance.mounted) {
                  HomePage.instance.setState(() {});
                }
                Navigator.of(context).pop();
              });
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      'Add Event Title',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 0) {
                          return 'Please add a valid title';
                        } else
                          return null;
                      },
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(descNode);
                      },
                      controller: titleController,
                      maxLines: 1,
                      decoration: new InputDecoration(
                          hintText: 'Title',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      'Add Event Description',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      focusNode: descNode,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: descController,
                      maxLines: 20,
                      decoration: new InputDecoration(
                          hintText: 'Description',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
