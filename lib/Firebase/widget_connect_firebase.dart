
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class MyFirebaseConnect extends StatefulWidget {
  final String errorMessage;
  final String connectingMessage;
  final Widget Function(BuildContext context) builder;

  const MyFirebaseConnect({super.key, required this.errorMessage, required this.connectingMessage, required this.builder});

  @override
  State<MyFirebaseConnect> createState() => _MyFirebaseConnectState();
}

class _MyFirebaseConnectState extends State<MyFirebaseConnect> {
  bool ketNoi = false;
  bool loi = false;
  @override
  Widget build(BuildContext context) {
    if(loi) {
      return
        Container(
          color: Colors.white,
          child: Center(
            child: Text(widget.errorMessage, style: TextStyle(fontSize: 16, color: Colors.red),
              textDirection: TextDirection.ltr,),
          ),
        );
    }
    if(ketNoi == false) {
      return
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(widget.connectingMessage, style: TextStyle(fontSize: 16), textDirection: TextDirection.ltr,)
              ],
            ),
          ),
        );
    }
    else return widget.builder(context);
  }
  @override
  void initState(){
    super.initState();
    _khoiTaoFirebase();
  }
  _khoiTaoFirebase(){
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => {
      setState(() {
        ketNoi = true;
      })
    }).catchError((error){
      setState(() {
        loi = true;
      });
    }).whenComplete((){
      print("Hoan tat ket noi firebase");
    });
  }

}
