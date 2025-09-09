class Employee {
  final String id;
  String name;
  String email;
  String phone;
  String position;
  String department;
  double salary;
  DateTime hireDate;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.salary,
    required this.hireDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      position: json['position'],
      department: json['department'],
      salary: json['salary'],
      hireDate: DateTime.parse(json['hireDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'salary': salary,
      'hireDate': hireDate.toIso8601String(),
    };
  }
}
