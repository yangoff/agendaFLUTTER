import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  final _nameFocus = FocusNode();
  bool _userEdited = false;
  Contact _editedContact;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(_editedContact.name.isNotEmpty && _editedContact.name != null && _editedContact.name != "Novo Contato"){
                Navigator.pop(context, _editedContact);
              } else{
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
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
                    onTap: (){
                      ImagePicker.pickImage(source: ImageSource.camera).then((file){
                        if(file == null) return;
                        setState(() {
                          _editedContact.img = file.path;
                        });
                      });
                    }
                ),
                TextField(
                  focusNode: _nameFocus,
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
        ),
        onWillPop: _requestPop
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

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
      builder:(context){
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Ao sair as alterações serao apagadas"),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancelar")),
              FlatButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: Text("Sim"))
            ],
          );
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
