import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/models/user.dart';
import 'package:to_do/screens/auth/login.dart';
import 'package:to_do/services/auth/google_auth.dart';
import 'package:to_do/services/auth/mail_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId = '';
  late User_ currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<User_> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = loadUser();
  }

  Future<User_> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('Id') ?? "";
    });
    DocumentSnapshot doc =
        await _firestore.collection("Users").doc(userId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        currentUser = User_.fromMap(data);
      });
    }
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon:
                Icon(Icons.logout, color: const Color.fromARGB(255, 234, 8, 8)),
            onPressed: () => _handleLogout(),
          ),
        ],
      ),
      body: FutureBuilder<User_>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('An error occurred'));
          } else {
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Name: ${currentUser.name}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email: ${currentUser.email}'),
                  ),
                ),
                // Add more cards for other details
              ],
            );
          }
        },
      ),
    );
  }

  void _handleLogout() async {
    bool success = false;
    try {
      success = await AuthenticationService().logout();
    } catch (e) {
      success = await signOutFromGoogle();
    }

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } else {
      print('Logout failed');
    }
  }
}
