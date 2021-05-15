import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login.dart';

class SignupScreen extends StatefulWidget {
  static const ROUTE_SIGNUP = '/route-signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                      'assets/images/sign.png',
                      fit: BoxFit.contain,
                    ),
                    width: 500,
                    height: 200,
                  ),
                ),
                SizedBox(height: 50),
                nameInp(),
                emailInp(),
                passInp(),
                signupBtn(),
                anoWid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passInp() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Password ',
          hintText: 'xxxxxxxx',
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
          if (input == null || input.isEmpty)
            return 'please enter a password';
          else if (input.length < 5) return 'must be atleast 5 characters';
          return null;
        },
        controller: _passCtrl,
      ),
    );
  }

  Widget emailInp() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email ',
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
          if (input == null || input.isEmpty)
            return 'Please enter a valid email address';
          return null;
        },
        controller: _emailCtrl,
      ),
    );
  }

  Widget nameInp() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Full Name',
          hintText: 'like Suryaraj Baranwal',
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.deepPurple[800],
            width: 4,
            style: BorderStyle.solid,
          )),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String input) {
          if (input == null || input.isEmpty) return 'Please enter a name';
          return null;
        },
        controller: _nameCtrl,
      ),
    );
  }

  Widget signupBtn() {
    return ElevatedButton(
      onPressed: () => perform(),
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void perform() async {
    String name = _nameCtrl.text;
    String email = _emailCtrl.text;
    String pass = _passCtrl.text;
    if (_formKey.currentState.validate()) {
      print('ashutosh');
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        User _currentUser = userCredential.user;
        _currentUser.sendEmailVerification(); //to verify user

        storeUserDetails(context, _currentUser.uid, name, email);
        notifyUser(
          context,
          'An email with verification link has been sent to you.',
        );
        Navigator.pushNamed(context, LoginScreen.ROUTE_LOGIN);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          notifyUser(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          notifyUser(context, 'The account already exists for that email.');
        }
      } catch (e) {
        notifyUser(context, e);
      }
    }
  }

  Widget anoWid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already a register User ! '),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
          },
          child: Text(
            'Login',
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

  void notifyUser(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }

  void storeUserDetails(context, String uid, String name, String email) async {
    Map<String, dynamic> userDetails = {
      'name': name,
      'email': email,
      'desc': 'Nothing right now',
      'image': '',
    };
    await FirebaseFirestore.instance
        .collection('user') // creating collection
        .doc(uid) // creating new document
        .set(userDetails) // adding data to the document
        .then((_) => notifyUser(context, 'User registered'))
        .catchError((onError) => notifyUser(context, onError));
  }
}
