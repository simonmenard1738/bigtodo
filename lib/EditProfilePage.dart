import 'package:flutter/material.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

User currentUser = User('John Doe', 'johndoe@gmail.com');

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController new_user = new TextEditingController();
  TextEditingController new_email = new TextEditingController();
  String img = "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        img = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
            child: Center(child:Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.person, size: 50,),
                    IconButton(onPressed: (){
                      Navigator.of(context).pushNamed('landingPage');
                    }, icon: Icon(Icons.settings,), iconSize: 50,),
                  ],
                ),
                SizedBox(height: 50,),

                CircleAvatar(
                  radius: 65,
                  backgroundImage: NetworkImage("$img"),
                ),

                SizedBox(
                  height: 15,
                ),

                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Change Photo"),
                ),

                SizedBox(
                  height: 25,
                ),

                SizedBox(
                  width: 250,
                  height: 75,
                  child: TextField(
                    controller: new_user,
                    decoration: InputDecoration(
                      // filled: true,
                      //fillColor: Colors.white,

                        hintText: currentUser.username
                      //"New Username"
                    ),
                  ),
                ),

                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    controller: new_email,
                    decoration: InputDecoration(
                      // filled: true,
                      //fillColor: Colors.white,

                        hintText: currentUser.email
                      //"New Email"
                    ),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    if(new_user.text.isNotEmpty && new_email.text.isNotEmpty)
                      currentUser.username = new_user.text;
                    currentUser.email = new_email.text;
                    new_user.text = "";
                    new_email.text = "";
                  });

                }, child: Text("Save Changes"))
              ],
            ),
            )
        ));
  }
}
