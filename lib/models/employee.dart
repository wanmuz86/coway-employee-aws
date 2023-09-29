// 1) Create the class

class Employee {
  // 2) Create the properties
  // Follows Flutter convention : camel case
  final String name;
  final String empId;
  final String email;
  final String phone;

  // 3) Create the constructor of your class

Employee({ required this.name, required this.empId,
  required this.email, required this.phone});

 // 4) Create a JSON to Object (an Instance of Class) Transformer

factory Employee.fromJson(Map<String, dynamic> json){
  return Employee(
      name: json["name"],
      empId: json["empId"],
      email: json["email"],
      phone: json["tel"]);
}

// 5) Create an Array of JSON to List of Object Transformer

  static List<Employee> employeesFromJson(dynamic json ){
  // {"status":"OK", "data":[] } in the future change to json["data"]
    var searchResult = json;
    List<Employee> results = List.empty(growable: true);

    if (searchResult != null){

      searchResult.forEach((v)=>{
        results.add(Employee.fromJson(v))
      });
      return results;
    }
    return results;
  }




}