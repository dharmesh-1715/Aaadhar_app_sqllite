// import 'package:flutter/material.dart';
// import 'database_helper.dart'; // Import the DatabaseHelper class
//
// class ViewDataScreen extends StatefulWidget {
//   @override
//   _ViewDataScreenState createState() => _ViewDataScreenState();
// }
//
// class _ViewDataScreenState extends State<ViewDataScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;
//   late Future<List<Map<String, dynamic>>> _storedData;
//
//   @override
//   void initState() {
//     super.initState();
//     _storedData = _dbHelper.getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_new_rounded),
//             onPressed: () {
//               Navigator.pop(context); // Go back to the previous screen
//             }),
//         backgroundColor: Colors.grey[600],
//         title: Text('Stored Aadhaar Details'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         // Asynchronously fetch data
//         future: _storedData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             var data = snapshot.data!;
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 var userData = data[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Displaying Name
//                         Text(
//                           '${userData['firstName']} ${userData['lastName']}',
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue[700]),
//                         ),
//                         SizedBox(height: 8),
//                         Divider(thickness: 1, color: Colors.grey[400]),
//
//                         // Displaying other details
//                         Text(
//                           'Age: ${userData['age']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           'Mobile: ${userData['mobileNumber']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           'Aadhar Number: ${userData['aadhaarNumber']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'database_helper.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatefulWidget {
  @override
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  late DatabaseHelper databaseHelper;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper.instance;
    _loadData();
  }

  void _loadData() async {
    List<Map<String, dynamic>> fetchedUsers = await databaseHelper.getData();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text(
          'Submitted Data',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? Center(child: Text('No data available'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Displaying Name
                        Text(
                          '${user['first_name']} ${user['last_name']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 1, color: Colors.grey[400]),

                        // Displaying Age
                        Text(
                          'Age: ${user['age']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 6),

                        // Displaying Mobile Number
                        Text(
                          'Mobile: ${user['mobile_number']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 6),

                        // Displaying Aadhaar Number
                        Text(
                          'Aadhaar Number: ${user['aadhar_number']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
