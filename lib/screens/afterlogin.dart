import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/session/session_management.dart';
import 'package:flutter_app/storage/local_data.dart';

class AfterLoginScreen extends StatefulWidget {
  static const ROUTE_NEXT = '/route-dashboard';
  @override
  _AfterLoginScreenState createState() => _AfterLoginScreenState();
}

class _AfterLoginScreenState extends State<AfterLoginScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.bottomNavList[_selectedIndex]['title']),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if(v=='item')
              showAlertDialog(context);
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'item',
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 20,
                  children: [
                    Icon(Icons.remove_circle,color: Colors.deepPurple,),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: LocalData.bottomNavList[_selectedIndex]['Screen'],
      bottomNavigationBar: createBottomNav(),
    );
  }

  Widget createBottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: LocalData.bottomNavList[0]['title'],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: LocalData.bottomNavList[1]['title'],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: LocalData.bottomNavList[2]['title'],
        ),
      ],
      backgroundColor: Colors.purple[700],
      selectedItemColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: (int cIndex) {
        setState(() {
          _selectedIndex = cIndex;
        });
      },
    );
  }

  void showAlertDialog(
    BuildContext ctx,
  ) {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext con) => AlertDialog(
              title: Text('Logout Dialog'),
              content: Text('Dou you really want to sign out?'),
              actions: [
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.purple),
                  onPressed: () => Navigator.pop(ctx),
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app_sharp, color: Colors.purple),
                  onPressed: () {
                    SessionManagement.removeUser().then((value) =>
                        Navigator.pushNamedAndRemoveUntil(context,
                            LoginScreen.ROUTE_LOGIN, (route) => false));
                  },
                ),
              ],
            ));
  }
}
