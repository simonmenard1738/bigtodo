import 'dart:async';

import 'package:big_to_do/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user.dart';
import 'media.dart';
import 'userlist.dart';
import 'db.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController searchController = TextEditingController();

User currentUser = User.empty();

int currentIndex = 0;


int? user_id;



List<UserList> lists = [];
int selectedIndex = 0;

List<Media> searchedList = [];
List<String> filters = ["movie", "game", "book", "album"];




void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.dark,
        fontFamily: 'Helvetica',
      ),
      routes: <String, WidgetBuilder>{
        'landingPage': (context) => LandingPage(),
        'singleList': (context) => SingleList(),
        'homePage': (context) => HomePage(),
        'loginScreen': (context) => LoginScreen(),
        'registerPage': (context) => RegisterPage(),
        'listCreate': (context) => ListCreate(),
        'searchPage': (context) => Search(),
        'listPage': (context) => Lists()
      },
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>LandingPage()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Big To Do List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 50),),
            Image(image: AssetImage('images/logo.png'),),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  Mydb mydb = new Mydb(); // create an instance for the database (db object)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mydb.open(); // initialize the database and start to add students information
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image(image: AssetImage('images/apple.webp'),),
            Container(
              child:
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushNamed('loginScreen');
                }, child: Text("Enter the app"))
            )
          ],
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();


  List<Map> ulist = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }



  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      await mydb.open();
      ulist = await mydb.db.rawQuery('select * from User');
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login",
          style: TextStyle(
            fontSize: 30,

          ),),
        toolbarHeight: 100,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Username: "),
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: ()async{
              String user = username.text;
              String pass = password.text;


              var userId = await mydb.checkUserCredentials(user, pass);

              if (userId!=-1) {
                currentUser = await mydb.getUser(userId);
                user_id = userId;
                // Navigate to the home page
                Navigator.of(context).pushNamed('homePage');
              } else {
                // Show a Snackbar indicating incorrect information
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect information'),
                  ),
                );
              }
            }, child: Text("Login")),

            SizedBox(
              height: 30,
            ),
            Text("Don't have an account?"),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:
                      (context) => RegisterPage()));
            },
                child: Text("Register"))
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage> {
  TextEditingController Reg_username = new TextEditingController();
  TextEditingController Reg_password = new TextEditingController();
  TextEditingController Reg_email = new TextEditingController();

  List<Map> ulist = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    getData();
    super.initState();
  }

  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      ulist = await mydb.db.rawQuery('select * from User');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register", style: TextStyle(
          fontSize: 30,
        ),),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Center(
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Please enter your info", style: TextStyle(
                  fontSize: 30
              )),

              SizedBox(height: 50,),

              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
                child: TextField(
                  controller: Reg_email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
              ), //
              SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
                child: TextField(
                  controller: Reg_username,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
                child: TextField(
                  controller: Reg_password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(onPressed: () async{
                currentUser = new User(Reg_username.text, Reg_email.text);
                String username = Reg_username.text;
                String email = Reg_email.text;
                String password = Reg_password.text;

                await mydb.insertUser(username, email, password);
                user_id = mydb.lastInsertedUserId;

                Navigator.of(context).pushNamed('homePage');
              }, child: Text("Register"))
            ]
        ),

      ),
    );
  }
}


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

  List<Map> ulist = [];
  Mydb mydb = new Mydb();


  String? new_username;
  String? new_emailer;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   mydb.open();
  //   getData();
  //   var user;
  //   user = ulist.map((user));
  //   new_username = user['username'];
  //   new_emailer = user['email'];
  //   super.initState();
  // }

  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await mydb.open();
     getData();

    if (ulist.isNotEmpty) {
      // Assuming ulist is a List<Map<dynamic, dynamic>> and you want the first user
      var user = ulist.first;

      setState(() {
        new_username = user['username'];
        new_emailer = user['email'];
      });
    }
  }


  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      ulist = await mydb.db.rawQuery('select * from User where user_id =' + user_id.toString());
      print("CURRENT USER ID:" + user_id.toString());

      setState(() {});
    });
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
                currentUser.username = new_user.text.isNotEmpty ? new_user.text : currentUser.username;
                currentUser.email = new_email.text.isNotEmpty ? new_email.text : currentUser.email;
                mydb.updateUser(currentUser.username, currentUser.email, user_id);
                getData();
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


class RatingsScreen extends StatefulWidget {
  Media selected;
  RatingsScreen(this.selected, {super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState(selected);
}

class _RatingsScreenState extends State<RatingsScreen> {
  Media selected;
  _RatingsScreenState(this.selected);

  List<Widget> stars = [];

  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(selected.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white)
              ),
              constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 350
              ),
              child: selected.poster.isNotEmpty ? Image.network(selected.poster) : Text(""),
            ),

            SizedBox(height: 35,),

            Text(selected.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                )),

            SizedBox(height: 35,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ADD RATINGS.
              children: [
                //Icon(Icons.star, color: Colors.orange, size: 40,),
                //Icon(Icons.star, color: Colors.orange, size: 40,),
                //Icon(Icons.star, color: Colors.orange, size: 40,),
                //Icon(Icons.star, color: Colors.orange, size: 40,),
                //Icon(Icons.star, color: Colors.orange, size: 40,),

              ],

            ),
          ],
        ),
      ),
    );
  }
}





class HomePage extends StatefulWidget {
  int? index;
  HomePage({super.key}){}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{


  _HomePageState();

  List<Widget> tabs = [
    EditProfile(),
    Search(),
    Lists()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lists"),
      ],
      ),
      body: tabs[currentIndex],
    );
  }
}

class Lists extends StatefulWidget {
  const Lists({super.key});

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {

  List<Map> ulists = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    getData();
    super.initState();
  }

  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      lists = [];
      var listResults = await mydb.db.rawQuery('select * from UserList where user_id =' +user_id.toString());
      String name = "";
      for(var row in listResults){
       var mediaResults =  await mydb.getList_Media(row['user_list_id'] as int);
       List<Media> mediaList = [];
       if(mediaResults!=null){
        for(var mediaRow in mediaResults){
          Map<dynamic, dynamic>? mediaMap = mediaRow['media_id']==null ? null : await mydb.getMedia(mediaRow['media_id']);
          if(mediaMap!=null)
            mediaList.add(Media(mediaMap['title'], mediaMap['year'], mediaMap['mediaType'], mediaMap['poster']??"", checked: mediaMap['checked']==1, id: mediaMap['media_id'].toString()));

        }
       }


       name = row['name'] as String;

       // need to get medias and add to list
       var list = UserList(name);
       list.medias = mediaList;
       lists.add(list);
     }
      setState(() {});
    });
  }

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
      padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: SingleChildScrollView(
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

class SingleList extends StatefulWidget {
  const SingleList({super.key});

  @override
  State<SingleList> createState() => _SingleListState();
}

class _SingleListState extends State<SingleList> {
  
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    Noti.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }
  
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
                      mydb.checkMedia(element.id, element.checked ? 1 : 0);
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
      padding: EdgeInsets.fromLTRB(20,60,20,20),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ Column(children: loadedList(context),),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Return"))
            ]
        ),
      )


    );
  }
}




class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is the user view"),
    );
  }
}

class Search extends StatefulWidget {
  Search({super.key});


  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ApiService service = ApiService();
  String currentFilter = "";
  List<Media> filteredList = [];

  List<Map> ulists = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    getData();
    super.initState();
  }

  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      setState(() {});
    });
  }

  void filter(String value){
    if(value!="-1" && searchedList.isNotEmpty){
      List<Media> temp = List<Media>.from(searchedList.where((element) => element.mediaType.toLowerCase()==value));
      if(temp.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No media found for this media type."), duration: Duration(seconds: 1),));
      }else{
        currentFilter = value;
        filteredList = temp;
      }
      print("value : ${searchedList}");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please search something before clicking one of these."), duration: Duration(seconds: 1),));
    }

  }

  List<Media> returnList() => filteredList.isEmpty ? searchedList : filteredList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        Container(
          child:
              ListTile(
                title: TextField(controller: searchController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), fillColor: Colors.white, hintText: "Find anything!", filled: true, hintStyle: TextStyle(color: Colors.grey)), style: TextStyle(color: Colors.black)),
                trailing: IconButton(onPressed: () async{
                  String search = searchController.text;
                  searchedList = [];
                  filteredList = [];
                  service.search(search).then((value) {

                    setState(() {
                      print("1 $searchedList");
                      if(value!=null){
                        for(Media media in value){
                          searchedList.add(media);
                        }
                      }
                      print("2 $searchedList");
                    });
                  });

                  searchController.clear();
                }, icon: Icon(Icons.search)),
              )


          ),

        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            padding: EdgeInsets.all(0),
            childAspectRatio: 4/1,
            shrinkWrap: true,

            children: [
              RadioListTile(value: filters[0], onChanged: (value){
                setState(() {
                  if(currentFilter!=value && value!=null){
                    print(value);
                    filter(value as String);
                  }else{
                    filteredList = [];
                    currentFilter = "";
                  }

                });
              }, groupValue: currentFilter, title: Text("Movies"), toggleable: true,),
              RadioListTile(
                value: filters[1], onChanged: (value){
                  setState(() {
                    if(currentFilter!=value && value!=null){
                      print(value);
                      filter(value as String);
                    }else{
                      filteredList = [];
                      currentFilter = "";
                    }

                  });
                }, groupValue: currentFilter, toggleable: true,
                title: Text("Games"),
              ),
              RadioListTile(
                value: filters[2], onChanged: (String? value){
                  setState(() {
                    if(currentFilter!=value && value!=null){
                      print(value);
                      filter(value as String);
                    }else{
                      filteredList = [];
                      currentFilter = "";
                    }

                  });
                }, groupValue: currentFilter, toggleable: true,
                title: Text("Books"),
              ),
              RadioListTile(
                value: filters[3],onChanged: (value){
                  setState(() {
                    if(currentFilter!=value && value!=null){
                      print(value);
                      filter(value as String);
                    }else{
                      filteredList = [];
                      currentFilter = "";
                    }

                  });
                }, groupValue: currentFilter, toggleable: true,
                title: Text("Music"),
              ),
            ],
          ),
        ),

        Expanded(child: Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(itemCount: returnList().length, shrinkWrap: true, itemBuilder: (context, index){
              return Card(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(title: Text(returnList()[index].title, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(returnList()[index].year),
                    Text(returnList()[index].mediaType)
                  ],
                ), onTap: (){
                  showModalBottomSheet(context: context, builder: (BuildContext context){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 500,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: listButtons(returnList()[index], context),
                        ),
                      ),
                    );

                  });
                },
                ),
              );})

        ), flex: 1,)

      ],
    );
  }

  List<Widget> listButtons(Media selected, BuildContext context){
    print("In List: $searchedList");
    List<Widget> globalLists = [];
    globalLists.add(Text("${selected.title}: ${selected.mediaType}, ${selected.year}", style: TextStyle(fontWeight: FontWeight.bold)));
    print(selected.poster);
    if(selected.poster!="N/A"){
      if(selected.poster.isNotEmpty)
        globalLists.add(Image.network(selected.poster, width: 200));
    }
    for (var element in lists) {
      globalLists.add(
          ElevatedButton(onPressed: () async{
            if(element.medias.where((element) => element.title==selected.title).isEmpty){
              int isChecked = 0;
              if(selected.checked == true){
                isChecked = 1;
              }

              mydb.insertMedia(selected.title, selected.year, selected.mediaType, isChecked, selected.poster);
              var result = await mydb.db.rawQuery("SELECT * FROM UserList WHERE name = '${element.name}'");
                int id = result[0]['user_list_id'] as int;
                int? mediaID = mydb.lastInsertedMediaId;
                mydb.insertMediaList(id, mediaID);
              setState(() {
                element.medias.add(selected);
              });
            }
            Navigator.pop(context);
          }, child: Text(element.name, style: TextStyle(color: Colors.black54),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),)
      );
    }
    return globalLists;
  }
}

class ListCreate extends StatefulWidget {
  ListCreate({super.key});

  @override
  State<ListCreate> createState() => _ListCreateState();
}

class _ListCreateState extends State<ListCreate> {
  TextEditingController listController = TextEditingController();

  List<Map> ulist = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    getData();
    super.initState();
  }

  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // use delay min 500ms, because database takes time to reinitialize
      ulist = await mydb.db.rawQuery('select * from User');
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListTile(
            title: TextField(decoration: InputDecoration(hintText: "Name"), controller: listController,),
            trailing: IconButton(onPressed: (){
              mydb.insertUserList(listController.text, user_id);
              //lists.add(UserList(listController.text));
              Navigator.of(context).pushNamed("homePage");
            }, icon: Icon(Icons.add)),)
        ),
      );
  }
}










