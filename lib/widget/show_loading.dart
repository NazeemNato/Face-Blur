import 'package:flutter/material.dart';

void showLoading(BuildContext context){
showDialog(
  context: context,
  barrierDismissible: false,
  builder:(_)=>WillPopScope(
    onWillPop: _willPopCallback,
    child: AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0)),
         content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Image cooking....',
                        style:TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    ),
  )
  );
}
Future<bool> _willPopCallback() async {
  return false;
}