import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class UpdateStatusScreen extends StatefulWidget {
  @override
  _UpdateStatusScreenState createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  bool isLoaded = false;
  List data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    Map map = {'custName': 'Aviral Agarwal'};

    String url = 'http://localhost:27017/posts/findMultiple';
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

  _changeToNotAlloted(String id) async {
    Map map = {'custId': id, 'newCustStatus': "Not Alloted"};
    String url = 'http://localhost:27017/posts/updateOneUseId';
    var response = await apiRequest(url, map);

    setState(() {
      print(response);
    });
  }

  _changeToAlloted(String id) async {
    Map map = {'custId': id, 'newCustStatus': "Alloted"};
    String url = 'http://localhost:27017/posts/updateOneUseId';
    var response = await apiRequest(url, map);

    setState(() {
      print(response);
    });
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              isLoaded = false;
              fetchData();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(
            'All Jobs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          data != null
              ? Container(
                  child: ListView(
                      shrinkWrap: true,
                      children: data.map((item) {
                        return Card(
                          child: Column(
                            children: <Widget>[
                              Text("Name- ${item["custName"]}"),
                              Text("Address- ${item["custAddress"]}"),
                              Text("Status- ${item["status"]}"),
                              Text("Id- ${item["_id"]}"),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      child: Text(
                                        'Alloted',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        _changeToAlloted(item["_id"]);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      child: Text(
                                        'NotAlloted',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        _changeToNotAlloted(item["_id"]);
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList()),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
