import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/event.dart';
import 'package:todo/loader.dart';
import 'package:todo/login_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    setState(() {});
}
  @override
  Widget build(BuildContext context) {
    var totalEvents = InheritedEventWidget.of(context).eventListInfo;
    return Loader(inAsyncCall: isLoading,
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
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => CreateEvent()));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: totalEvents.eventList.length > 0 ? Container(
            child: ListView.builder(
                itemCount: totalEvents.eventList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.teal.shade100
                      ),
                      color: Colors.teal.shade50,
                    ),
                    child: ListTile(
                      title: Text(totalEvents.eventList[index].title),
                    ),
                  );
                }),
          ) :
              Center(child: Text('Add Events'),),
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
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Loader(inAsyncCall: isLoading, child: Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Add event'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async{
          CollectionReference eventRef = await FirebaseFirestore.instance
              .collection('customers')
              .doc(LoginInfo.customerDocID)
              .collection("to_do_events");
          Map<String, dynamic> dataToInsert = new Map();
          dataToInsert['title'] = titleController.text.trim();
          dataToInsert['desc'] = descController.text.trim();
          isLoading = true;
          setState(() {

          });
          await eventRef.add(dataToInsert).then((value)  {

            setState((){
              isLoading = false;
              titleController.text = '';
              descController.text = '';
            });

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
                child: Text('Add Event Title', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
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
                  maxLines:  1,
                  decoration: new InputDecoration(
                      hintText: 'Title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Text('Add Event Description', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
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
                  maxLines:  20,
                  decoration: new InputDecoration(
                      hintText: 'Description',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
