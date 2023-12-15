import 'package:big_to_do/userlist.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ListCreate extends StatelessWidget {
  ListCreate({super.key});
  TextEditingController listController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(hintText: "Name"), controller: listController,),
              ElevatedButton(onPressed: (){
                lists.add(UserList(listController.text));
                Navigator.of(context).pushNamed("homePage");
              }, child: Text("Add list"))
            ],
          ),
        )
    );
  }
}
