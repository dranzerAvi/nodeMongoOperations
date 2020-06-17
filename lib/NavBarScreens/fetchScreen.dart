import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FetchScreen extends StatefulWidget {
  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  String serverResponse = 'Server response';

  bool isLoaded = false;
  List data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await http.get('http://localhost:27017/posts/listall');
//    var response = await http
//        .get('https://rest-api-avi-seventeen-june.herokuapp.com/posts/listall');

    print(response.body);
    setState(() {
      data = jsonDecode(response.body);
      isLoaded = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    data = null;
    isLoaded = false;
    print('bjhsavdu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Server Testing',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                isLoaded = false;
                fetchData();
              });
            },
            icon: Icon(Icons.refresh),
            color: Colors.black,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                shrinkWrap: true,
                children: data.map((item) {
                  return Card(
                    margin: EdgeInsets.all(15),
                    color: Colors.teal,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          item["custName"],
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          item["pickupAddress"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        Text(
                          item["destAddress"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  _makeGetRequest() async {
    Response response = await get('${_localhost()}:27017/posts/listall');
    setState(() {
      serverResponse = response.body;
    });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000';
    else // for iOS simulator
      return 'http://localhost';
  }
}
