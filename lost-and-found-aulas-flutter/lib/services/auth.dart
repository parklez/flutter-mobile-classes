import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lost_and_found/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {

  static Future<String> signIn(String email, String password) async {
    final auth = FirebaseAuth.instance;
    final result = await auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    final auth = FirebaseAuth.instance;
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static Future<void> addUser(User user) async {
    checkUserExist(user.userId).then((value) {
      if (!value) {
        Firestore.instance
            .document("users/${user.userId}")
            .setData(user.toMap());
      }
    });
  }

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userId").get().then((doc) {
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<User> getUser(String userId) {
    if (userId != null) {
      return Firestore.instance
          .collection('users')
          .document(userId)
          .get()
          .then((documentSnapshot) => User.fromDocument(documentSnapshot));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  static String getExceptionText(Exception error) {
    if (error is PlatformException) {
      switch (error.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  static Future<String> storeUserLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = user.toJson();
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = User.fromJson(prefs.getString('user'));
      return user;
    } else {
      return null;
    }
  }
}
