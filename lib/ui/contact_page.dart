import 'dart:io';

import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _phoneControler = TextEditingController();
  bool _userEdited = false;
  Contact _editedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: null,
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null ? FileImage(File(_editedContact.img)): AssetImage("images/man.png")
                    )),
              ),
            ),
            TextField(
              controller: _nameControler,
              decoration: InputDecoration(
                labelText: "Nome",
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  if(text == ""){
                    _editedContact.name = "Novo Contato";
                  }else{
                    _editedContact.name = text;
                  }

                });
              },
            ),
            TextField(
              controller: _emailControler,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              onChanged: (text){
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneControler,
              decoration: InputDecoration(
                labelText: "Phone",
              ),
              onChanged: (text){
                _userEdited = true;
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameControler.text = _editedContact.name;
      _emailControler.text = _editedContact.email;
      _phoneControler.text = _editedContact.phone;

    }
  }
}
