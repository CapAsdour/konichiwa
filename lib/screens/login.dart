import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/afterlogin.dart';
import 'package:flutter_app/screens/signup.dart';
import 'package:flutter_app/session/session_management.dart';

class LoginScreen extends StatefulWidget {
  static const ROUTE_LOGIN = '/route-login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[10],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Image.asset(
                    'assets/images/login.png',
                    fit: BoxFit.contain,
                  ),
                  width: 400,
                  height: 200,
                ),
              ),
              SizedBox(height: 50),
              emailInp(),
              passInp(),
              loginBtn(),
              anotherWidget(),
            ],
          )),
        ),
      ),
    );
  }

  Widget emailInp() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email :',
          hintText: 'xxx@email.com',
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.deepPurple[800],
            width: 4,
            style: BorderStyle.solid,
          )),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String input) {
          if (input == null ||input.isEmpty) return 'please enter your email address';
          return null;
        },
        controller: _emailCtrl,
      ),
    );
  }

  Widget passInp() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Password :',
          hintText: 'xxxxxxxxxx',
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.deepPurple[800],
            width: 4,
            style: BorderStyle.solid,
          )),
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (String input) {
          if (input == null ||input.isEmpty)
            return 'please enter a password';
          else if (input.length < 5) return 'must be atleast 5 characters';
          return null;
        },
        controller: _passCtrl,
      ),
    );
  }

  Widget loginBtn() {
    return ElevatedButton(
      onPressed: performLogin,
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void performLogin() async {
    if (_formKey.currentState.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailCtrl.text, password: _passCtrl.text);

        User user = userCredential.user;

        if (user.emailVerified) {
          notifyUser(context, 'Login Successful');
          SessionManagement.storeLogin(uid: user.uid);
          Navigator.pushReplacementNamed(context, AfterLoginScreen.ROUTE_NEXT);
        } else
          notifyUser(context, 'Need to verify mail');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          notifyUser(context, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          notifyUser(context, 'Wrong password provided for that user.');
        }
      }
    }
  }

  void notifyUser(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }

  Widget anotherWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Want to register now? '),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, SignupScreen.ROUTE_SIGNUP);
          },
          child: Text(
            'SignUp',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
