import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/screens/conversation.dart';
import 'package:flutter_app/session/session_management.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<User> _userList = [];
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  String _currUserID;

  @override
  void initState() {
    super.initState();
    createContactList();
    //getting user id from local session
    SessionManagement.getLoginUID().then((value) {
      setState(() {
        _currUserID = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int i) {
        User _user = _userList[i];
        return Wrap(children: [
          ListTile(
            leading: _user.imageUrl == ''
                ? Icon(Icons.person)
                : CircleAvatar(
                    backgroundImage: NetworkImage(_user.imageUrl),
                  ),
            title: Text(_user.name),
            subtitle: Text(_user.UserDesc),
            onTap: () {
              print('${_user.UserEmail}');
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => Conversation(user: _user),),);
            },
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
        ]);
      },
      itemCount: _userList.length,
    );
  }

  void createContactList() async {
    await ref.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs
          .where((doc) => doc.id != _currUserID)
          .forEach((DocumentSnapshot doc) {
        //properly named user within [] is acc. to the one of firebase
        User user = User(
            name: doc['name'],
            desc: doc['desc'],
            email: doc['email'],
            imageUrl: doc['image']);
        _userList.add(user);
      });
      //print('total size : ${_userList.length}');
    }).catchError((onError) => print(onError));
  }
}
