import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import '../loader.dart';
import '../login_info.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Loader(
      inAsyncCall: LoginInfo.isSendingOTP,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          titleSpacing: 0,
          brightness: Brightness.dark,
          backgroundColor: Color(0xff7b72df),
          title: Text(
            'WELCOME TO',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body:Container(
          color: Color(0xfff4f4f4),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.47,
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
                      height: MediaQuery.of(context).size.height / 2.4,
                      child: Image.asset(
                        "assets/images/login_img.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'We will send you an',
                      //textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' One Time Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' on this mobile number',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'Enter Mobile number',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flag(
                          "IN",
                          height: 30,
                          width: 30,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 180,
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 1),
                          child: CupertinoTextField(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  //                   <--- left side
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              color: Colors.transparent,
                            ),
                            controller: phoneController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            maxLength: 10,
                            placeholder: '+91...',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(LoginInfo.errorMsg, style: TextStyle(color: Colors.red),),
                    ) ,
                  ],
                ),

              ),

              Center(
                child: FloatingActionButton(
                  onPressed: () {
                    if (LoginInfo.isSendingOTP) {
                      return;
                    }
                    LoginInfo.isSendingOTP = true;

                    LoginInfo.sendOTPToMobileNumber(
                        context, phoneController.text.toString(), this);
                    setState(() {});
                  },
                  backgroundColor: Colors.deepOrange,
                  child: Icon(
                    Icons.arrow_forward,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  void dispose() {
    phoneController?.dispose();
    super.dispose();
  }
}