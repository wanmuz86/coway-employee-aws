import 'dart:io';
import 'dart:convert';

import 'package:employee_app/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  final String empId;
  const DetailPage({super.key, required this.empId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // THis is where employee will be stored
  // Before API call, this variable is null
  // We need to use ? to declare a nullable variable
  Employee? _employee;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _base64String;

  @override
  void initState() {
    super.initState();
    fetchEmployee().then((value)  {
      setState((){
        _employee = value;
        nameEditingController.text = value.name;
        empIdEditingController.text = value.empId;
        phoneEditingController.text = value.phone;
        emailEditingController.text =value.email;
      });


    });
  }

  var nameEditingController = TextEditingController();
  var empIdEditingController = TextEditingController();
  var phoneEditingController = TextEditingController();
  var addressEditingController = TextEditingController();
  var emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(title: Text("Detail Page"),
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        body: _employee == null ? Center(child: CircularProgressIndicator(),) :
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () async{
                  print("tapped");

                  //final ImagePicker _picker = ImagePicker();
                  final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });

                    // Convert the picked image to a base64 encoded string
                    final bytes = await _imageFile!.readAsBytes();
                   _base64String = base64Encode(bytes);
                    print('Base64 encoded image: $_base64String');
                  }
                }, child: Text("Open library")),
                GestureDetector(
                  onTap: ()  {



                    // open photo library
                  },
                  child: Container(
                    height:100,
                    width:100,
                    child: _imageFile != null ?   Image.file(_imageFile!) : Placeholder(),
                  ),
                ),
               TextField(decoration: InputDecoration(hintText: "Enter user name"), controller: nameEditingController,),
                TextField(decoration: InputDecoration(hintText: "Enter user email"),controller: emailEditingController,),
                TextField(decoration: InputDecoration(hintText: "Enter user employeeId"), controller: empIdEditingController,),
                TextField(decoration: InputDecoration(hintText: "Enter user phone"), controller: phoneEditingController,),
                TextField(decoration: InputDecoration(hintText: "Enter user address"), controller: addressEditingController,),
                ElevatedButton(onPressed: (){
                  updateEmployee(nameEditingController.text, empIdEditingController.text,
                      emailEditingController.text, phoneEditingController.text, _base64String!);

                }, child: Text("Update Info"))
              ],
            ),
          ),
        )
    );
  }
  // We are working with {}
  // <> will have ClassName
  Future<Employee> fetchEmployee() async {
    print("https://c1s7sqf3ya.execute-api.ap-southeast-1.amazonaws.com/employees/${widget.empId}");
    final response = await http
        .get(Uri.parse('https://c1s7sqf3ya.execute-api.ap-southeast-1.amazonaws.com/employees/${widget.empId}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // Since We are working with {} -> fromJson
      // jsonDecode -> import dart:convert
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load employee');
    }
  }
  Future<void> updateEmployee(String name, String empId, String email, String phone, String image) async {
    // Code to get the token from Shared Preference
   // var token = "eyJraWQiOiJIV2NGeG44Q1wvVkVoMVJETzVPUTFYRDR1XC8xRlNsR1ZjS3lGeVZEd0pSdFU9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1MjYyMTA5Ni1kYWYxLTQ1MDQtODVjZi1mOWY3ZDkxMjE4ZTUiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbVwvYXAtc291dGhlYXN0LTFfWmdja2MyVEpFIiwidmVyc2lvbiI6MiwiY2xpZW50X2lkIjoiNGF0bWZhOHJhczRicmltb3A0czUyamYxYXEiLCJldmVudF9pZCI6ImVmMTNjYzA0LWQwN2YtNGE0OS05NjhlLTIxNDE0NTNhNmI0YiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4gcGhvbmUgb3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhdXRoX3RpbWUiOjE2OTU5NzI0NjUsImV4cCI6MTY5NTk3NjA2NSwiaWF0IjoxNjk1OTcyNDY1LCJqdGkiOiIzZTUzMGMyMy1mNTc3LTRjYjQtOGI1Mi02ZDg4NzE2MTY4NDgiLCJ1c2VybmFtZSI6IjUyNjIxMDk2LWRhZjEtNDUwNC04NWNmLWY5ZjdkOTEyMThlNSJ9.cjvCVQaYjqjSo8UluMGjSByI029ShgssUtpqrWC68L8edlE1KSyGzJOGLTdjNPGyKNBpg5k2TK8Kj_k08NI7RWd-EnD_kvPOn_eY-D-ZHAhg7DN5VITmgmWzWc9CADnKWepbQWIb5IPPfxx8XcWE-cdzlD7a9odO0Bc5-QZdn1AtKZ1bKYEck352lhXySUH1DUlBm9Q7I9BPDH3RNqDr7OTaV73NFKgFLpt5F3fI4NdO2GQDBm-pacsSgYZqxsGsrkonptBHYGmKwVEEoHa1z3tLDz8G24bQg7XsxefexkG5zWgNe8bBwQfIbmP71xLtY-W2m6oBJbfq2GeQ6NNvvA";
    final response = await http.put(
      Uri.parse('https://c1s7sqf3ya.execute-api.ap-southeast-1.amazonaws.com/employees/$empId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'empId':empId,
        'email':email,
        'tel':phone,
        'profile_pic':image,
        "address":"123 test"
      }),
    ).catchError((err, stackTrace) {
      print(err);
    });

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
    //  return Employee.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
    // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create employee.');
    }
  }
}
