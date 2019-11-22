import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static String uid;
  static Future<void> sendVerificationCode(
      {String number,
      Function(AuthCredential) verificationCompleted,
      Function(AuthException) verificationFailed,
      Function(String, [int]) codeSent,
      Function(String) codeAutoRetrievalTimeout}) async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  static Future<bool> signIn(AuthCredential cred) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(cred);
      uid = result.user.uid;
      prefs.setString('uid', uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  static void signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance.signOut();
    prefs.remove('uid');

  }

  static AuthCredential verifyCode(String smsCode, String verificationId) {
    AuthCredential cred = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    return cred;
  }

  static Future<bool> userExist() async {
    DocumentSnapshot snap =
        await Firestore.instance.collection('users').document(uid).get();
    if (snap.exists) {
      return true;
    }
    return false;
  }

}
