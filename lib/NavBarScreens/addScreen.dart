import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final pickupController = TextEditingController();
  final destController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pickupController.dispose();
    destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Server Testing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: pickupController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter PickupAddress'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: destController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter destination Address'),
            ),
          ),
          FlatButton(
            onPressed: _addPost,
            child: Text('Add new job'),
          )
        ],
      ),
    );
  }

  _addPost() async {
    String url = 'http://localhost:27017/posts/add1docu';
//    String url =
//        'https://rest-api-avi-seventeen-june.herokuapp.com/posts/add1docu';

    Map map = {
      'custName': 'Aviral Agarwal',
      'custAddress':
          'Cecilia Chapman 711-2880 Nulla St. Mankato Mississippi 96522 (257) 563-7401',
      'custPhno': '+917060222315',
      'pickupAddress': pickupController.text,
      'destAddress': destController.text,
      'status': 'notAlloted'
    };

    print(await apiRequest(url, map));

    print('Document added');
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
}
