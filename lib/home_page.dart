import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imagefile;

  var firstname = "";
  var lastname = "";
  var gender = "";
  var dob = "";
  var email = "";

  @override
  void initState() {
    getValues();
    super.initState();
  }

  void getValues() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstname = prefs.getString('fname') ?? '';
      lastname = prefs.getString('lname') ?? '';
      gender = prefs.getString('gender') ?? '';
      dob = prefs.getString('dob') ?? '';
      email = prefs.getString('email') ?? '';
      String? imagePath = prefs.getString('imagePath');
      if (imagePath != null ) {
        _imagefile = File(imagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: _imagefile != null
                  ? FileImage(_imagefile!)
                  : AssetImage('assets/new.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Name',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(firstname,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Last Name',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,height: 34,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    lastname,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Gender',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,height: 34,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'Date of Birth',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,height: 34,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    dob,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'Email address',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,height: 34,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    email,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      minimumSize: Size(MediaQuery.of(context).size.width, 60)
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder:(context) =>
                          EditProfile()),).then((_){
                            getValues();
                    }
                    );
                  },
                  child: Text('Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 20),
                ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
