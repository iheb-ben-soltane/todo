import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/models/user.dart';
import 'package:to_do/screens/app.dart';
import 'package:to_do/screens/auth/forgetPass.dart';
import 'package:to_do/services/auth/google_auth.dart';
import 'package:to_do/services/auth/mail_auth.dart';

import 'signUp.dart';

bool validateMail(String mail) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(mail);
  return emailValid;
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  AuthenticationService auth = AuthenticationService();
  final _SignInFomKey = GlobalKey<FormState>();
  ValueNotifier<UserCredential?> userCredential = ValueNotifier(null);
  String email = '';
  String pass = '';
  String err = '';
  bool showPassword = true;
  @override
  void initState() {
    //  AuthenticationService().logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    toastMsg(String msg, BuildContext theContext) {
      ScaffoldMessenger.of(theContext).showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 46, 219, 228),
      ));
    }

    Size size = MediaQuery.of(context).size;

    Widget InputField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (val) => (val == null || !validateMail(val.toString()))
                ? 'Email format incorect'
                : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              hintText: "user@mail.tn",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 133, 228, 233),
                    width: 3.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 3.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            onChanged: (value) {
              setState(() => email = value);
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    Widget InputPassField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (val) => (val == null || val.length < 6)
                ? 'the password should have at least six characers. '
                : null,
            obscureText: showPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              hintText: 'password',
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  (showPassword) ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 133, 228, 233),
                    width: 3.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 3.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() => pass = value);
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    Widget GoogleBTN(BuildContext cntx) {
      return Container(
          height: 40,
          width: size.width * 0.7,
          child: ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google icon

                Image.asset(
                  'assets/google_icon.png', // Replace with the path to your Google icon image
                  height: 25,
                  width: 28,
                ),

                SizedBox(
                  width: 15,
                ),
                Text(
                  "Sign in with Google",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 133, 228, 233),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onPressed: () async {
              userCredential.value = await signInWithGoogle();
              print(
                  'Logged in user given name: ${userCredential.value?.additionalUserInfo?.profile?['given_name']}');
              if (userCredential.value != null) {
                print(userCredential.value!.user!.email);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                  (route) => false,
                );
              }
            },
          ));
    }

    Widget LogInBTN(BuildContext cntx) {
      return Container(
          height: 40,
          width: size.width * 0.7,
          child: ElevatedButton(
            child: Text(
              "LOGIN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 133, 228, 233),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onPressed: () async {
              final formStatus = _SignInFomKey
                  .currentState; // Change _signUpFormKey to _SignInFomKey
              if (formStatus!.validate() == true) {
                User_? res = await auth.loginWithEmailAndPassword(email, pass);
                print('Logged in user: $res');
                if (res != null) {
                  // Login successful, navigate to the desired screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => App()),
                    (route) => false,
                  );
                } else {
                  // Handle login failure
                  print('Failed to login');
                }
              }
            },
          ));
    }

    Widget FinalLine() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("you don't have an account ? "),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text(
            "create one ! ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 241, 184, 135)),
          ),
        )
      ]);
    }

    Widget forgetPass() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Text(
            "have you forgot your password ? ",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 241, 135, 135)),
          ),
        )
      ]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, 100),
            child: Transform.scale(
              scale: 2.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Form(
                key: _SignInFomKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 250,
                    ),
                    Text(
                      "Welcome !",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "login to continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Column(
                        children: [
                          InputField(),
                          SizedBox(
                            height: 10,
                          ),
                          InputPassField(),
                          SizedBox(
                            height: 30,
                          ),
                          LogInBTN(context),
                          SizedBox(
                            height: 20,
                          ),
                          GoogleBTN(context),
                          Text(
                            err,
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 228, 233),
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    forgetPass(),
                    FinalLine(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
