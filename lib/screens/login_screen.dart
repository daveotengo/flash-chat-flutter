import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static String id ='login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
//var email = "tony@starkindustries.com"
class _LoginScreenState extends State<LoginScreen> {
final _auth= FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email=value;
                  //Do something with the user input.
                },
                  decoration:KInputDecoration.copyWith(hintText: 'Enter your Email')

              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                 // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                //if(emailValid) {
                  password = value;
                // }else{
                //   print('email problem');
                // }
                  //Do something with the user input.
                },
                decoration:KInputDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async{
                  //setState(() {

setState(() {
  showSpinner = true;
});
                    print(password);
                    print(email);
                    try {
                      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                          email: '$email',
                          password: '$password'
                      );

                        if(userCredential!=null){
                          setState(() {
                            showSpinner = false;
                          });
                          print('entered mtd');

                          Navigator.pushNamed(context, ChatScreen .id);
                        }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }else{
                        print(e.code);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    }

                    // try {
                    //   print('button pressed');
                    //   /// Navigator.pushNamed(context, ChatScreen .id);
                    //
                    //   final loggedInUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    //   print(loggedInUser);
                    //   if(loggedInUser!=null){
                    //     print('entered mtd');
                    //
                    //     Navigator.pushNamed(context, ChatScreen .id);
                    //   }
                    //
                    //
                    // }catch(e){
                    //   print('errrrr****');
                    //
                    //   print(e);
                    // }

                 // });
                  //Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
