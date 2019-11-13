import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instant/utilities/Auth.dart';
import 'package:instant/widgets/GradiantButton.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File profileImage;
  bool nameError = false;
  bool usernameError = false;
  bool loading = false;
  bool imageError = false;
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      imageError = false;
      profileImage = image;
    });
  }

  validateProfile() async{
    int errorCount = 0;

    setState(() {
      loading = true;
      nameError = false;
      usernameError = false; 
      imageError = false;
    });
    if(name.text == ''){
      errorCount += 1;
      nameError = true;
    }
    if(username.text == ''){
      errorCount += 1;
      usernameError = true;
    }else if(await Auth.usernameExist(username.text)){
      errorCount += 1;
      usernameError = true;
      username.clear();
    }

    if(profileImage == null){
      errorCount += 1;
      imageError = true;
    }

    if(errorCount == 0){
      print("success");
    }

    setState(() {
     loading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Your Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 33)),
            ),
            GestureDetector(
              onTap: getImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: imageError?5:0,
                    color: imageError?Colors.redAccent:Colors.black,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: profileImage == null
                          ? AssetImage('assets/default.png')
                          : FileImage(profileImage),
                      fit: BoxFit.fill),
                  ),
              ),
            ),
            Column(
              children: <Widget>[
                TextField(
                  controller: name,
                  maxLength: 30,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      suffixIcon: Icon(
                        Icons.error_outline,
                        color: nameError ? Colors.redAccent : Colors.black,
                      ),
                      hintText: "Full Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
                TextField(
                  controller: username,
                  maxLength: 30,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.fingerprint,
                        color: Colors.grey,
                      ),
                      suffixIcon: Icon(
                        Icons.error_outline,
                        color: usernameError ? Colors.redAccent : Colors.black,
                      ),
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
                TextField(
                  controller: bio,
                  maxLength: 200,
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.language,
                        color: Colors.grey,
                      ),
                      hintText: "Bio",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                )
              ],
            ),
            loading
                ? SpinKitWave(color: Colors.white, size: 30.0)
                : GradiantButton(
                    text: "Create Profile",
                    onTap: validateProfile,
                  ),
          ],
        ),
      ),
    );
  }
}
