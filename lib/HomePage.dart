import 'package:flutter/material.dart';
import 'EditProfilePage.dart';
import 'SearchPage.dart';
import 'main.dart';
import 'Noti.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  @override
  void initState(){
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  void dispose() {
    Noti.showBigTextNotification(title: "Big To Do List", body: "Don't Forget to check your List", fln: flutterLocalNotificationsPlugin);
    super.dispose();
  }

  int currentIndex = 0;

  List<Widget> tabs = [
    EditProfile(),
    Search(),
    Lists(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lists"),
        ],
      ),
    );
  }
}

class Lists extends StatefulWidget {
  const Lists({super.key});

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {

  void deleteList(int index) {
    setState(() {
      lists.removeAt(index);
    });
  }

  List<Widget> generatedLists(){
    List<Widget> widgetList = [];
    lists.forEach((element) {
      widgetList.add(
        Card(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ListTile(title: Text(element.name, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Text("${element.medias.length} Medias",), onTap: (){
            selectedIndex = lists.indexOf(element);
            Navigator.of(context).pushNamed('singleList');
          }, trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
            //HERE, ADD CODE TO DELETE THE LIST!!!!
            deleteList(lists.indexOf(element));
          },),
          ),
        ),
      );
    });
    return widgetList;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: generatedLists()),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushNamed("listCreate");
              }, child: Text("Add List")),
            ],),
        )
    );
  }
}