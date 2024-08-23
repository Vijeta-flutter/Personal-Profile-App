import 'dart:io';
import 'package:first/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _imagefile;
  final ImagePicker _picker = ImagePicker();

  var firstnameText = TextEditingController();
  var lastnameText = TextEditingController();
  var genderText = "";
  var dobText = TextEditingController();
  var emailText = TextEditingController();
  var genderlist = ['Male','Female'];

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstnameText.text = prefs.getString('fname') ?? '';
      lastnameText.text = prefs.getString('lname') ?? '';
      genderText = prefs.getString('gender') ?? '';
      dobText.text = prefs.getString('dob') ?? '';
      emailText.text = prefs.getString('email') ?? '';
      String? imagePath = prefs.getString('imagePath');
      if (imagePath != null && imagePath.isNotEmpty) {
        _imagefile = File(imagePath);
      }
    });
  }

  void pickImage(ImageSource source) async{
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null){
      setState(() {
        _imagefile = File(image.path);
      });
    }
  }

  Future<void> setData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fname', firstnameText.text);
    prefs.setString('lname', lastnameText.text);
    prefs.setString('gender', genderText);
    prefs.setString('dob', dobText.text);
    prefs.setString('email', emailText.text);
    if (_imagefile != null) {
      await prefs.setString('imagePath', _imagefile!.path);
    } else {
      prefs.remove('imagePath');
    }
  }
  void saveChanges() async{
    print("Save Changes button pressed");
    await setData();
    print("Data saved successfully");
    Navigator.pop(context);
  }

  Future<DateTime?> selectDate(BuildContext context) async{
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Page'),
        backgroundColor: Colors.cyanAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("Take a photo"),
                            onTap: () {
                              pickImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text("Choose from gallery"),
                            onTap: () {
                              pickImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _imagefile != null
                      ? FileImage(_imagefile!)
                      :AssetImage('assets/new.png') as ImageProvider,
                  child: _imagefile == null
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.black,)
                      :null,
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  controller: firstnameText,
                  decoration: InputDecoration(
                    hintText: "Your First Name",
                    labelText: 'First Name',
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: lastnameText,
                decoration: InputDecoration(
                  hintText: "Your Last Name",
                  labelText: "Last Name",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: TextEditingController(text: genderText),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Gender",
                  labelText: "Gender",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: DropdownButton<String>(
                          isExpanded: true,
                          value: genderText.isEmpty ? null : genderText,
                          hint: Text("Select Gender"),
                          items: genderlist.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              genderText = newValue!;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: dobText,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Your Date of Birth",
                  labelText: "Date of Birth",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async{
                  DateTime? pickDate = await selectDate(context);
                  if (pickDate != null) {
                    setState(() {
                      dobText.text = "${pickDate.day}/${pickDate.month}/${pickDate.year}";
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: emailText,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  labelText: "Email",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {saveChanges();},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  minimumSize: Size(MediaQuery.of(context).size.width, 60)
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      fontSize: 20,
                  color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
