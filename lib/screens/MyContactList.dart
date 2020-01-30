import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyContactDetails.dart';
import '../DbHelper.dart';
import '../MyContact.dart';

class MyContactList extends StatefulWidget {
  @override
  _MyContactListState createState() => _MyContactListState();
}

class _MyContactListState extends State<MyContactList> {

  DbHelper _dbHelper = DbHelper();
  List<MyContact> _myContactList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(_myContactList == null)
    {
      _myContactList = List<MyContact>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Contacts"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => this._navigationToDetail("Create contact", MyContact("", "")),
      ),
    );
  }

  void onHorizontalDragStart()
  {
    print("onHorizontalDragStart");
  }

  ListView getNoteListView() =>
  ListView.builder(
    itemCount: count, 
    itemBuilder: (BuildContext context, int index) { 
      return Dismissible(
        key: UniqueKey(),
        
        direction: DismissDirection.horizontal,
        onDismissed: (direction) async
        {
          
          if (direction == DismissDirection.startToEnd) 
          {
            // left to right drag
            await launch("tel:${this._myContactList[index].number}");
          }
          else if (direction == DismissDirection.endToStart)
          {
            // right to left drag
            await launch("sms:${this._myContactList[index].number}");
          }

          updateListView();
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          color: Colors.green,
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(15),
          color: Colors.blue,
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            leading: InkWell(
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
              // onTap: () => _navigationToDetail("Edit contact", _myContactList[index]),
            ),
            title: Text(this._myContactList[index].name),
            subtitle: Text(this._myContactList[index].number),
            onTap: () => _navigationToDetail("Edit contact", _myContactList[index]),
          ),
        ),
      );
    },
  );


  void _navigationToDetail(String title, MyContact myContact) async
  {

    bool result = await Navigator
      .push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => MyContactDetails(title, myContact)
      )
    );

    if (result) {
      updateListView();
    }
  }

  updateListView()
  {
    final Future<Database> dbFuture = this._dbHelper.initializeDatabase();
    dbFuture.then((db) 
    {
      Future<List<MyContact>> myContactListFuture = this._dbHelper.getMyContactList();
      myContactListFuture.then((myContactList)
      {
        setState(() {
          this._myContactList = myContactList;
          this.count = myContactList.length;
        });
      });
    });
  }
}