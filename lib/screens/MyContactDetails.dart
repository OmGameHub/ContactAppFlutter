import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DbHelper.dart';
import '../MyContact.dart';

class MyContactDetails extends StatefulWidget {

  final String appBarTitle;
  final MyContact _myContact;

  MyContactDetails(this.appBarTitle, this._myContact);

  @override
  _MyContactDetailsState createState() => _MyContactDetailsState(this.appBarTitle, this._myContact);
}

class _MyContactDetailsState extends State<MyContactDetails> {

  DbHelper dbHealper = DbHelper();

  String appBarTitle;
  MyContact _myContact;

  TextEditingController nameContaroller = TextEditingController();
  TextEditingController numberContaroller = TextEditingController();
  TextEditingController emailContaroller = TextEditingController();

  _MyContactDetailsState(this.appBarTitle, this._myContact);

  @override
  void initState() {
    nameContaroller.text = _myContact.name;
    numberContaroller.text = _myContact.number;
    emailContaroller.text = _myContact.email;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: moveToLastScreen,
        ),
        title: Text(this.appBarTitle),
        actions: <Widget>[

          // save btn start
          InkWell(
            customBorder: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Text("Save"),
            ),
            onTap: this._save,
          ),
          // save btn end

          // delete btn start
          Visibility(
            visible: this._myContact.id != null,
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: this._delete,
            ),
          ),
          // delete btn end

        ],
      ),
      body: _body(),
    );
  }

  // page body start
  Widget _body() =>
  WillPopScope(
    onWillPop: () { 
      moveToLastScreen();
    },
    child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: <Widget>[

            // name input field start
            userInput(
              nameContaroller, 
              this.updateName,
              "Name", 
              Icon(Icons.person_outline),
              TextInputType.text,
            ),
            // name input field end

            // number input field start
            userInput(
              numberContaroller, 
              this.updateNumber,
              "Mobile number", 
              Icon(Icons.phone),
              TextInputType.phone,
            ),
            // number input field end

            // email input field start
            userInput(
              emailContaroller, 
              this.updateEmail,
              "Email", 
              Icon(Icons.mail_outline),
              TextInputType.emailAddress,
            ),
            // email input field end

            // user action btn list start
            Visibility(
              visible: this._myContact.id != null,
              child: Column(
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        // call acction btn start
                        userActionBtn(
                          Icons.call,
                          Colors.green,
                          this._callAction,
                        ),
                        // call acction btn end

                        // message acction btn start
                        userActionBtn(
                          Icons.message,
                          Colors.blue,
                          this._messageAction,
                        ),
                        // message acction btn end

                        // email acction btn start
                        userActionBtn(
                          Icons.mail_outline,
                          Colors.pink,
                          this._mailAction,
                        ),
                        // email acction btn end

                      ],
                    ),
                  ),

                  Divider(),
                ],
              ),
            ),
            // user action btn list end

          ],
        ),
      ),
    ),
  );
  // page body end

  // user input start
  Widget userInput(controller, updateText, labelText, icon, keyboardType) => 
  Padding(
    padding: EdgeInsets.only(top: 5, bottom: 15),
    child: TextField(
      controller: controller,
      onChanged: (value) => updateText(),
      decoration: InputDecoration(
        // border: OutlineInputBorder(),
        labelText: labelText,
        icon: icon,
      ),
      keyboardType: keyboardType,
    ),
  );
  // user input end

  // user action btn start
  Widget userActionBtn(iconName, bgColor, onTap) =>
  Card(
    color: bgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100)
    ),
    child: InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Icon(
          iconName,
          size: 32,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    ),
  );
  // user action btn end

  void _callAction() async
  {
    await launch("tel:${this._myContact.number}");
  }

  void _messageAction() async
  {
    await launch("sms:${this._myContact.number}");
  }

  void _mailAction() async
  {
    await launch("mailto:${this._myContact.email}");
  }

  void moveToLastScreen() => Navigator.pop(context, true);

  void updateName() => this._myContact.name = this.nameContaroller.text;

  void updateNumber() => this._myContact.number = this.numberContaroller.text;

  void updateEmail() => this._myContact.email = this.emailContaroller.text;

  void _save() async
  {
    moveToLastScreen();

    int result;
    if (this._myContact.id != null) 
    {
      result = await dbHealper.updateMyContact(this._myContact);
    } 
    else 
    {
      result = await dbHealper.insertMyContact(this._myContact);
    }

    if (result != 0) {
      _showAlertDialog("Status", "Saved successfully");
    } else {
      _showAlertDialog("Status", "Problem in saving contact");
    }
  }

  void _delete() async
  {
    moveToLastScreen();

    if (this._myContact.id == null) {
      _showAlertDialog("Status", "First add contact");
      return;
    }
    
    int result = await dbHealper.deleteMyContact(this._myContact.id);
    if (result != 0) {
      _showAlertDialog("Status", "Contact deleted");
    } else {
      _showAlertDialog("Status", "Error");
    }
  }

  void _showAlertDialog(String title, String message)
  {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}