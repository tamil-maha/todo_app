import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import '../loader.dart';
import '../login_info.dart';

class VerifyOTP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerifyOTPState();
  }
}

class _VerifyOTPState extends State<VerifyOTP> {
  List<Color> _colors = [Color(0xffff595f), Color(0xffff595f)];
  List<double> _stops = [0.1, 0.8];

  String text = '';

  void _onKeyboardTap(String value) {
    text = text + value;

    if (text.length == 6) {
      LoginInfo.isVerifyingOTP = true;

      LoginInfo.validateOtpAndLogin(context, text);
    }
    setState(() {});
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 20),
        )),
      );
    } catch (e) {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0),
            color: Colors.white.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          "-",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 30),
        )),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginInfo.isSendingOTP = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Loader(
      inAsyncCall: LoginInfo.isVerifyingOTP,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          titleSpacing: 0,
          brightness: Brightness.light,
          title: Text('hi'),
          centerTitle: true,
          elevation: 1,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Icon(
              Icons.lock,
              color: Colors.black,
            ),
            Container(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xfff4f4f4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: Colors.white10,
                            borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Image.asset(
                                "assets/images/login_img.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: Colors.grey,
                            size: 50,
                          ),
                          Container(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Column(
                              children: [
                                Text(
                                  "Please type the verification code sent to ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Text(
                                  LoginInfo.phoneNumber,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            otpNumberWidget(0),
                            otpNumberWidget(1),
                            otpNumberWidget(2),
                            otpNumberWidget(3),
                            otpNumberWidget(4),
                            otpNumberWidget(5),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Center(
                          child: Text(
                            LoginInfo.errorMsg,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                NumericKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  textColor: Colors.grey[600],
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Colors.grey,
                  ),
                  rightButtonFn: () {
                    setState(() {
                      text = text.substring(0, text.length - 1);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
