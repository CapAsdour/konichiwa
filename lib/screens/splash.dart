import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/afterlogin.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/session/session_management.dart';
import 'package:flutter_app/storage/local_data.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext cxt, AsyncSnapshot snapshot) {
        return Scaffold(
          /*appBar: AppBar(
          title: Text('Chennai Super Kings'),
        ),*/
          /*body: Center(
          child: Text('Wistle Podu'),
        ),*/
          body: SafeArea(
            child: Column(
              children: [
                //Spacer(),
                Text(""),
                Text(
                  "Konichiwa!",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                imageZone(),
                /* Expanded(
                                       child: Image.asset('assets/images/octocat.png'),
                                     ),*/
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      //based on the connection with server,
                      //trying to initiate routing
                      if (snapshot.connectionState == ConnectionState.done) {
                        //routing screens
                        performRouting(context);
                      } else {
                        // ignore: todo
                        //TODO:add widget
                        print('Network not connected');
                      }
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(fontFamily: 'Comfortaa'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*body: Row(
                                                         children: [
                                                           Text('Wistle Podu'),
                                                           Expanded(
                                                               child: Image.asset('assets/images/octocat.png'),
                                                           ),
                                                         ],
                                                       ),*/
        );
      },
    );
  }

  Widget imageZone() {
    return Container(
      height: 400,
      child: PageView.builder(
        itemBuilder: (ctx, index) => Column(
          children: [
            Expanded(
              child: ClipRRect(
                child: Image.asset(LocalData.pagerList[index]['image']),
              ),
            ),
            Text(LocalData.pagerList[index]['title'])
          ],
        ),
        itemCount: LocalData.pagerList.length,
      ),
    );
  }

  void performRouting(BuildContext context) {
    SessionManagement.getLoginStatus().then((value) {
      if (value)
        Navigator.pushReplacementNamed(context, AfterLoginScreen.ROUTE_NEXT);
      else
        Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
    }).catchError((onError) => print(onError));
  }
}
