import 'package:flutter/material.dart';
import 'RatingPage.dart';
import 'main.dart';
import 'package:big_to_do/Noti.dart';

class SingleList extends StatefulWidget {
  const SingleList({super.key});

  @override
  State<SingleList> createState() => _SingleListState();
}

class _SingleListState extends State<SingleList> {

  @override
  List<Widget> loadedList(BuildContext context){
    List<Widget> widgetList = [];

    lists[selectedIndex].medias.forEach( (element) {
      widgetList.add(
        Card(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ListTile(onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>RatingsScreen(element)
            ));
          },title: Text(element.title, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(element.year),
              Text(element.mediaType)
            ],
          ),
              trailing: Container(
                child: Checkbox(onChanged: (index){
                  setState(() {
                    if(lists[selectedIndex].isEditable){
                      element.check();
                      checkIfAllChecked();
                    }else{
                      Noti.showBigTextNotification(title: "Big To Do List", body: "Can't uncheck archived list", fln: flutterLocalNotificationsPlugin);
                    }
                  });

                },value: element.checked,),
              )

          ),
        ),

      );
    }
    );

    return widgetList;
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void checkIfAllChecked() {
    bool allChecked = lists[selectedIndex].medias.every((element) => element.checked);
    if (allChecked) {
      showCompletionDialog();
    }
  }
  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("List Completed"),
          content: Text("What would you like to do?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  lists[selectedIndex].isEditable = false;
                });
                Navigator.of(context).pop();
              },
              child: Text("Archive the List"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the search page
                Navigator.pushReplacementNamed(context, 'homePage');
              },
              child: Text("Go to home Page (for now)"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(children: loadedList(context) + [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Return"))
      ]),
    );
  }
}

