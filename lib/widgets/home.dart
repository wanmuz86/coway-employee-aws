import 'package:employee_app/widgets/add.dart';
import 'package:flutter/material.dart';
import '../models/employee.dart';
import 'detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Map<String,String>> <- Before
  // List<Employee> <- After
  List<Employee> _employees = [

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Call the function fetchEmployees,
    // Then the transformed data from the API call will be inside values
    // fetchEmployees().then((value) => {
    //   setState((){
    //     _employees = value;
    //   })
    //
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: Text("Home Page"),
      ),
      body: Column(
        children: [
          Center(
            child: Image.network(
                "https://images.thedirectbusiness.com/wp-content/uploads/2023/01/Coway-Logo-2023.png",
            width: 200,),
          ),

          FutureBuilder<List<Employee>>(
              future: fetchEmployees(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  return  Expanded(
                    child: ListView.builder(
                      // How many rows are there
                        itemCount: snapshot.data!.length,
                        // What to show every row
                        itemBuilder: (context,index){
                          return Card(
                            child: ListTile(
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].empId),
                              trailing: Icon(Icons.chevron_right),
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>DetailPage(empId:
                                    snapshot.data![index].empId,)));
                              },

                            ),
                          );
                        }),
                  );
                } else if (snapshot.hasError){
                   return Center(child: Text("Something is wrong ${snapshot.hasError}"),);
                }
                return Center(child: CircularProgressIndicator(),);
              },
            ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var item = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPage()));

          if (item !=null){
            setState(() {
              fetchEmployees();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
  // Data Type future means it is an asynchoronous function
  // Eg of Asynchronous function: API Call, Database, Shared Preference, Navigator.push (Future)
  // - When you call method returning future, you need to use  : 1) async await 2) then
  // Inside <>, the data type returned by the methods
  // if you are working with [] -> List<ClassName>
  // If you are working with {} -> ClassName
  Future<List<Employee>> fetchEmployees() async {
    // Missing import
    //import 'package:http/http.dart' as http;
    final response = await http
        .get(Uri.parse('https://c1s7sqf3ya.execute-api.ap-southeast-1.amazonaws.com/employees'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // If you are working with [] -> 5th method in your class -> employeesFromJson
      // If you are working with {} => 4th method in your class -> fromJson

      // jsonDecode  -> Transform String into object
      return Employee.employeesFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load employees');
    }
  }

  // Callback function to refresh data.

}
