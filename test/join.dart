library itertools.join.test;

import 'package:unittest/unittest.dart';
import '../lib/itertools.dart';

void defineTests() {
  group("join iterables:", () {
    testGroupJoin();
    testInnerJoin();
    testLeftOuterJoin();
  });
}

//Example taken from wikipedia.
class Employee {
  final int employeeId;
  final String lastName;
  final int departmentId;

  const Employee(int this.employeeId, String this.lastName, int this.departmentId);

  String toString() => "Employee($employeeId, $lastName, $departmentId)";

  bool operator ==(Object other) =>
      (other is Employee) && other.employeeId == employeeId;
}

class Department {
  final int departmentId;
  final String departmentName;

  const Department(int this.departmentId, String this.departmentName);

  String toString() => "Department($departmentId, $departmentName)";

  bool operator ==(Object other) =>
      (other is Department) && other.departmentId == departmentId;
}

const List<Employee> employees =
    const [ const Employee(123, "Rafferty", 31),
            const Employee(224, "Jones", 33),
            const Employee(525, "Heisenberg", 34),
            const Employee(012, "Smith", 34),
            const Employee(001, "John", null)
          ];

const List<Department> departments =
    const [ const Department(31, "Sales"),
            const Department(33, "Engineering"),
            const Department(34, "Clerical"),
            const Department(35, "Marketing")
          ];


void testGroupJoin() {
  test("employee departments group join", () {
    var departmentEmployees =
        groupJoin( departments,
                   employees,
                   innerKey: (department) => department.departmentId,
                   outerKey: (employee) => employee.departmentId);
    expect(departmentEmployees,
           unorderedEquals(
               [ new Grouping(const Department(31, "sales"), [const Employee(123, "Rafferty", 31)]),
                 new Grouping(const Department(33, "Engineering"), [const Employee(224, "Jones", 33)]),
                 new Grouping(const Department(34, "Clerical"), [ const Employee(525, "Heisenberg", 34),
                                                                  const Employee(012, "Smith", 34)]),
                 new Grouping(const Department(35, "Marketing"), [])
               ]));
  });
}

testInnerJoin() {

  test("inner join default selector", () {
    var departmentEmployees =
        innerJoin(
            departments,
            employees,
            innerKey: (department) => department.departmentId,
            outerKey: (employee) => employee.departmentId);
    expect(departmentEmployees,
        unorderedEquals(
            [ new Tuple2(const Department(31, "sales"), const Employee(123, "Rafferty", 31)),
              new Tuple2(const Department(33, "Engineering"), const Employee(224, "Jones", 33)),
              new Tuple2(const Department(34, "Clerical"), const Employee(525, "Heisenberg", 34)),
              new Tuple2(const Department(34, "Clerical"), const Employee(012, "Smith", 34))
            ]));
  });
  test("Inner join, select string", () {
    var departmentEmployees =
        innerJoin(
            departments,
            employees,
            innerKey: (department) => department.departmentId,
            outerKey: (employee) => employee.departmentId,
            selector: (department, employee) => "${employee.lastName} (${department.departmentName})");
    expect(
        departmentEmployees,
        [ "Rafferty (Sales)", "Jones (Engineering)", "Heisenberg (Clerical)", "Smith (Clerical)"]);
  });
}

testLeftOuterJoin() {

  test("left outer join default selector", () {
    var departmentEmployees =
        leftOuterJoin(
            departments,
            employees,
            innerKey: (department) => department.departmentId,
            outerKey: (employee) => employee.departmentId);
    expect(departmentEmployees,
        unorderedEquals(
            [ new Tuple2(const Department(31, "sales"), const Employee(123, "Rafferty", 31)),
              new Tuple2(const Department(33, "Engineering"), const Employee(224, "Jones", 33)),
              new Tuple2(const Department(34, "Clerical"), const Employee(525, "Heisenberg", 34)),
              new Tuple2(const Department(34, "Clerical"), const Employee(012, "Smith", 34)),
              new Tuple2(const Department(35, "Marketing"), null)
            ]));
  });
  test("Left outer join join, select string", () {

    //Example obviously more interesting as a join the other way round, but this is just a test.
    var departmentEmployees =
        leftOuterJoin(
            departments,
            employees,
            innerKey: (department) => department.departmentId,
            outerKey: (employee) => employee.departmentId,
            selector: (department, employee) =>
                "${employee != null ? employee.lastName : "No employees"} (${department.departmentName})");
    expect(
        departmentEmployees,
        [ "Rafferty (Sales)",
          "Jones (Engineering)",
          "Heisenberg (Clerical)",
          "Smith (Clerical)",
          "No employees (Marketing)"
        ]);
  });

}