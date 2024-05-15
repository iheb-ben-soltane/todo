import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/models/user.dart';

// Sign in with Google
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    late SharedPreferences prefs;
    // Check if the user canceled the sign-in process
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Await the signInWithCredential call to get the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print("User signed successfully");
    // Access the user property from the UserCredential
    final user = userCredential.user;
    prefs = await SharedPreferences.getInstance();
    prefs.setString('Id', user!.uid);
    prefs.setString('email', user.email!);
    // Check if the user already exists in Firestore before adding
    final userExists = await FirebaseFirestore.instance
        .collection("Users")
        .where('email', isEqualTo: user.email)
        .get();

    if (userExists.docs.isEmpty) {
      Map<String, dynamic> map = {
        'Id': user.uid,
        'email': user.email,
        'lastName': user.displayName,
        'name': user.displayName,
        'profileImage': user.photoURL,
      };
      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .set(map);

      print("User added successfully");
    } else {
      print("User already exists in Firestore");
    }

    return userCredential;
  } catch (e) {
    print('Exception during sign-in: $e');
    return null;
  }
}

// Sign out from Google
Future<bool> signOutFromGoogle() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Sign out from Google
    await GoogleSignIn().signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  } catch (e) {
    print('Exception during sign-out: $e');
    return false;
  }
}
