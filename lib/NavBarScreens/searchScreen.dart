import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String serverResponse = 'Server response';
  final searchParamController = TextEditingController();

  bool isLoaded = false;
  List data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchParamController.dispose();
    super.dispose();
  }

  fetchData() async {
    Map map = {'custName': searchParamController.text};

    String url = 'http://localhost:27017/posts/findmultiple';
    var response = await apiRequest(url, map);
    var Str = response;
    setState(() {
      data = jsonDecode(Str);
      isLoaded = true;
    });

    print('Documents retrieved');
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
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchParamController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Enter Name'),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    fetchData();
                  },
                  child: Container(
                      color: Colors.teal,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Retrieve',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                data.length != 0
                    ? Container(
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
                      )
                    : Text('No such User found'),
              ],
            ),
    );
  }
}
