import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:todo/event.dart';

import 'login/verify_otp.dart';
import 'main.dart';

class LoginInfo {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String errorMsg = '';
  static User firebaseUser;
  static String phoneNumber;
  static bool isSendingOTP = false;
  static bool isVerifyingOTP = false;
  static String actualCode;
  static String customerDocID;
  static List<ToDoEvents> toDoEventList = new List();



  static Future<bool> loginCustomer() async {
    QuerySnapshot customerQuery = await FirebaseFirestore.instance
        .collection('customers')
        .where("customer_uid", isEqualTo: firebaseUser.uid)
        .get();
    if (customerQuery.docs.isEmpty) {
      CollectionReference addressRef =
          await FirebaseFirestore.instance.collection('customers');
      Map<String, dynamic> dataToInsert = new Map();
      dataToInsert['customer_uid'] = LoginInfo.firebaseUser.uid;
      await addressRef.add(dataToInsert).then((rsp) => customerDocID = rsp.id);
    } else {
      customerDocID = customerQuery.docs[0].id;
      //fetchEventList();
    }
    return true;
  }

  static Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      return await loginCustomer();
    } else {
      return false;
    }
  }

  static Future<void> sendOTPToMobileNumber(
      BuildContext context, String phoneNumber, State<Object> instance) async {
    LoginInfo.errorMsg = '';
    phoneNumber = "+91" + phoneNumber;
    LoginInfo.phoneNumber = phoneNumber;
    await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (AuthCredential auth) async {
              await _auth
                  .signInWithCredential(auth)
                  .then((UserCredential value) {
                if (value != null && value.user != null) {
                  print('Authentication successful');
                  LoginInfo.isSendingOTP = false;
                  onAuthenticationSuccessful(context, value);
                } else {
                  print('Invalid code/invalid authentication');
                  LoginInfo.isSendingOTP = false;
                  LoginInfo.errorMsg = 'Authentication Invalid';
                  if (instance.mounted) {
                    instance.setState(() {});
                  }
                }
              }).catchError((error) {
                print(error);
                LoginInfo.isSendingOTP = false;
                LoginInfo.errorMsg =
                    'Something has gone wrong, please try later';
                if (instance.mounted) {
                  instance.setState(() {});
                }
              });
            },
            verificationFailed: (FirebaseAuthException authException) {
              print('Error message: ' + authException.message);
              LoginInfo.isSendingOTP = false;
              LoginInfo.errorMsg = 'Enter valid phone number';
              if (instance.mounted) {
                instance.setState(() {});
              }
            },
            codeSent: (String verificationId, [int forceResendingToken]) async {
              actualCode = verificationId;
              LoginInfo.isSendingOTP = false;
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => VerifyOTP()));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              actualCode = verificationId;
            })
        .catchError((error) {
      print('Something has gone wrong, please try later');
      LoginInfo.isSendingOTP = false;
      LoginInfo.errorMsg = 'Something has gone wrong, please try later';
      if (instance.mounted) {
        instance.setState(() {});
      }
    });
  }

  static Future<void> onAuthenticationSuccessful(
      BuildContext context, UserCredential result) async {
    firebaseUser = result.user;
    await loginCustomer();
    LoginInfo.isSendingOTP = false;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (_) => MyApp(), settings: RouteSettings(name: "/APP")),
      (Route<dynamic> route) => false,
    );
  }

  static Future<void> validateOtpAndLogin(
      BuildContext context, String smsCode) async {
    isVerifyingOTP = true;
    LoginInfo.errorMsg = '';
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    await _auth.signInWithCredential(_authCredential).catchError((error) {
      isVerifyingOTP = false;
      LoginInfo.errorMsg = 'Wrong code ! Please enter the last code received';
      print('Wrong code ! Please enter the last code received.');
    }).then((UserCredential authResult) {
      if (authResult != null && authResult.user != null) {
        print('Authentication successful');
        onAuthenticationSuccessful(context, authResult);
      }
    });
  }

  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashPage()),
        (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}
