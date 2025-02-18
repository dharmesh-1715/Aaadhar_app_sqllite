import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ViewDataScreen.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(AadhaarApp());
}

class AadhaarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AadhaarForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AadhaarForm extends StatefulWidget {
  @override
  _AadhaarFormState createState() => _AadhaarFormState();
}

class _AadhaarFormState extends State<AadhaarForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper.instance;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final age = _ageController.text;
      final mobileNumber = _mobileNumberController.text;
      final aadharNumber = _aadharNumberController.text;

      // Prepare data for insertion into SQLite
      final userData = {
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'mobile_number': mobileNumber,
        'aadhar_number': aadharNumber,
      };

      try {
        // Insert data into SQLite
        await databaseHelper.insertUser(userData);
        // Show dialog if insertion is successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Details Submitted'),
            backgroundColor: Colors.grey[300],
            content: Text(
              'Name: $firstName $lastName\n\n'
              'Age: $age years\n\n'
              'Mobile Number: $mobileNumber\n\n'
              'Aadhaar Number: $aadharNumber\n\n',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        );

        // Clear form fields after submission
        _firstNameController.clear();
        _lastNameController.clear();
        _ageController.clear();
        _mobileNumberController.clear();
        _aadharNumberController.clear();
      } catch (e) {
        // Handle errors if insertion fails
        print('Error during insertion: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit data'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
        backgroundColor: Colors.grey[600],
        title: Text(
          'Aadhar Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name(as per Aadhar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter First Name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name(as per Aadhar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter Last Name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age(as per Aadhar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Age(as per Aadhar)';
                  } else if (int.tryParse(value) == null ||
                      int.parse(value) <= 0 ||
                      int.parse(value) >= 110) {
                    return 'Enter a valid Age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number(linked to Aadhar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Mobile Number';
                  } else if (value.length != 10) {
                    return 'Mobile Number must be 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _aadharNumberController,
                decoration: InputDecoration(
                  labelText: 'Aadhaar Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Aadhaar Number';
                  } else if (value.length != 12) {
                    return 'Aadhaar Number must be 12 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text(
                  'Submit Details',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, elevation: 10),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDataScreen()),
                  );
                },
                child: Text(
                  'View Submitted Data',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, elevation: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ViewDataScreen extends StatefulWidget {
//   @override
//   _ViewDataScreenState createState() => _ViewDataScreenState();
// }
//
// class _ViewDataScreenState extends State<ViewDataScreen> {
//   late DatabaseHelper databaseHelper;
//   List<Map<String, dynamic>> users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     databaseHelper = DatabaseHelper();
//     _loadData();
//   }
//
//   void _loadData() async {
//     List<Map<String, dynamic>> fetchedUsers =
//         await databaseHelper.getAllUsers();
//     setState(() {
//       users = fetchedUsers;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey[600],
//         title: Text(
//           'Submitted Data',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: users.isEmpty
//           ? Center(child: Text('No data available'))
//           : ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Displaying Name
//                         Text(
//                           '${user['first_name']} ${user['last_name']}',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue[700],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Divider(thickness: 1, color: Colors.grey[400]),
//
//                         // Displaying Age
//                         Text(
//                           'Age: ${user['age']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 6),
//
//                         // Displaying Mobile Number
//                         Text(
//                           'Mobile: ${user['mobile_number']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 6),
//
//                         // Displaying Aadhaar Number
//                         Text(
//                           'Aadhaar Number: ${user['aadhar_number']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//
//   Database? _database; // Changed from late to nullable Database?
//
//   DatabaseHelper._internal();
//
//   // Initialize the database (ensure it's ready for use)
//   Future<Database> get database async {
//     if (_database != null)
//       return _database!; // If database is already initialized, return it
//     _database = await _initDatabase(); // Otherwise, initialize it
//     return _database!; // Return the initialized database
//   }
//
//   Future<Database> _initDatabase() async {
//     final path = await getDatabasesPath();
//     return await openDatabase(
//       join(path, 'aadhaar.db'),
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE users(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             first_name TEXT,
//             last_name TEXT,
//             age TEXT,
//             mobile_number TEXT,
//             aadhar_number TEXT
//           )
//         ''');
//       },
//       version: 1,
//     );
//   }
//
//   Future<int> insertUser(Map<String, String> userData) async {
//     Database db = await database;
//     return await db.insert('users', userData);
//   }
//
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     Database db = await database;
//     return await db.query('users');
//   }
// }
