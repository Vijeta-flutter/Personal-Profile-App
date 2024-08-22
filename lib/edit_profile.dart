import 'dart:io';
import 'package:first/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var bloodgroupText = TextEditingController();
  var emailText = TextEditingController();
  var genderlist = [
    'Male',
    'Female'
  ];
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
      bloodgroupText.text = prefs.getString('blood') ?? '';
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
    prefs.setString('blood', bloodgroupText.text);
    prefs.setString('email', emailText.text);
    if (_imagefile != null) {
      await prefs.setString('imagePath', _imagefile!.path);
    } else {
      prefs.remove('imagePath');
    }
  }
  void saveChanges() async{
    await setData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 120,
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
              TextField(
                controller: firstnameText,
                decoration: InputDecoration(
                  hintText: "Your First Name",
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: lastnameText,
                decoration: InputDecoration(
                  hintText: "Your Last Name",
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: TextEditingController(text: genderText),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Gender",
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
              SizedBox(height: 20,),
              TextField(
                controller: bloodgroupText,
                decoration: InputDecoration(
                  hintText: "Your Blood Group",
                  labelText: "Blood Group",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: emailText,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 10,horizontal: 30
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
