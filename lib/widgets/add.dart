import 'package:flutter/material.dart';

import '../models/employee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPage extends StatelessWidget {
  var nameEditingController = TextEditingController();
  var idEditingController = TextEditingController();
  var emailEditingController = TextEditingController();
  var phoneEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Page"),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Please fill in all information"),
            TextField(decoration: InputDecoration(hintText: "Enter employee name"),
            controller: nameEditingController,),
            TextField(decoration: InputDecoration(hintText: "Enter employee ID"),
            controller: idEditingController,),
            TextField(decoration: InputDecoration(hintText: "Enter employee email"),
            keyboardType: TextInputType.emailAddress,
              controller: emailEditingController,
            ),
            TextField(decoration: InputDecoration(hintText: "Enter employee phone"),
            keyboardType: TextInputType.phone,
            controller: phoneEditingController,),
            // => ((value)=>{}) (Call and execute 1 line)
            // then ((value){})
            ElevatedButton(onPressed: (){

              createEmployee(nameEditingController.text,
                  idEditingController.text,
                  emailEditingController.text,
                  phoneEditingController.text).then((value){
                    print("Successfully added!");
                    // WE will replace with notifier on Friday
                    Navigator.pop(context, value);
                    // navigator.pop(context);

              });

            }, child: Text("Add new employee"))
          ],
        ),
      ),
    );
  }

  Future<Employee> createEmployee(String name, String empId, String email, String phone) async {
    // Code to get the token from Shared Preference
    var token = "eyJraWQiOiJIV2NGeG44Q1wvVkVoMVJETzVPUTFYRDR1XC8xRlNsR1ZjS3lGeVZEd0pSdFU9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1MjYyMTA5Ni1kYWYxLTQ1MDQtODVjZi1mOWY3ZDkxMjE4ZTUiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbVwvYXAtc291dGhlYXN0LTFfWmdja2MyVEpFIiwidmVyc2lvbiI6MiwiY2xpZW50X2lkIjoiNGF0bWZhOHJhczRicmltb3A0czUyamYxYXEiLCJldmVudF9pZCI6ImVmMTNjYzA0LWQwN2YtNGE0OS05NjhlLTIxNDE0NTNhNmI0YiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4gcGhvbmUgb3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhdXRoX3RpbWUiOjE2OTU5NzI0NjUsImV4cCI6MTY5NTk3NjA2NSwiaWF0IjoxNjk1OTcyNDY1LCJqdGkiOiIzZTUzMGMyMy1mNTc3LTRjYjQtOGI1Mi02ZDg4NzE2MTY4NDgiLCJ1c2VybmFtZSI6IjUyNjIxMDk2LWRhZjEtNDUwNC04NWNmLWY5ZjdkOTEyMThlNSJ9.cjvCVQaYjqjSo8UluMGjSByI029ShgssUtpqrWC68L8edlE1KSyGzJOGLTdjNPGyKNBpg5k2TK8Kj_k08NI7RWd-EnD_kvPOn_eY-D-ZHAhg7DN5VITmgmWzWc9CADnKWepbQWIb5IPPfxx8XcWE-cdzlD7a9odO0Bc5-QZdn1AtKZ1bKYEck352lhXySUH1DUlBm9Q7I9BPDH3RNqDr7OTaV73NFKgFLpt5F3fI4NdO2GQDBm-pacsSgYZqxsGsrkonptBHYGmKwVEEoHa1z3tLDz8G24bQg7XsxefexkG5zWgNe8bBwQfIbmP71xLtY-W2m6oBJbfq2GeQ6NNvvA";
    final response = await http.post(
      Uri.parse('https://c1s7sqf3ya.execute-api.ap-southeast-1.amazonaws.com/employees'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'empId':empId,
        'email':email,
        'tel':phone,
        'address':"Lot 123"
      }),
    ).catchError((err, stackTrace) {
      print(err);
    });

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create employee.');
    }
  }
}
