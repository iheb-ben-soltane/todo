import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/auth/mail_auth.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  static String id = 'forgot-password';
  final _SignInFomKey = GlobalKey<FormState>();
  String email = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      "Restore your password!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                validator: (val) => (val == null ||
                                        !EmailValidator.validate(
                                            val.toString()))
                                    ? 'Email format incorect'
                                    : null,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  hintText: "user@mail.tn",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 133, 228, 233),
                                        width: 3.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 133, 228, 233),
                                        width: 3.0),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 45,
                            width: size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_SignInFomKey.currentState!.validate() ==
                                    true) {
                                  try {
                                    AuthenticationService()
                                        .resetPassword(email);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Un lien est envoyé à votre adresse e-mail."),
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 15,
                                      backgroundColor: Colors.grey,
                                    ));
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(e.toString()),
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 15,
                                      backgroundColor:
                                          Color.fromRGBO(173, 17, 9, 0.435),
                                    ));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 133, 228, 233),
                                padding: const EdgeInsets.all(2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              child: Text(
                                "ENVOYER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "<- Retour ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
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
