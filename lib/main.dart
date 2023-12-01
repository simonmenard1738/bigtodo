import 'package:big_to_do/service.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'media.dart';
import 'userlist.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController searchController = TextEditingController();

User currentUser = User('John Doe', 'johndoe@gmail.com');

List<UserList> lists = [];
int selectedIndex = 0;

List<Media> searchedList = [];




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        'listCreate': (context) => ListCreate()
      },
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Big To Do List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 50),),
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed('homePage');
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
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(onPressed: (){
                currentUser = new User(Reg_username.text, Reg_email.text);
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

            ElevatedButton(onPressed: (){}, child: Text("Change Photo")),

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


class RatingsScreen extends StatefulWidget {
  Media selected;
  RatingsScreen(this.selected, {super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState(selected);
}

class _RatingsScreenState extends State<RatingsScreen> {
  Media selected;
  _RatingsScreenState(this.selected);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Ratings"),
      ),
      body: Center(
        child: Column(
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
              child: Image.network(selected.poster),
            ),

            SizedBox(height: 35,),

            Text(selected.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                )),

            SizedBox(height: 35,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 40,),
                Icon(Icons.star, color: Colors.yellow, size: 40,),
                Icon(Icons.star, color: Colors.yellow, size: 40,),
                Icon(Icons.star, color: Colors.yellow, size: 40,),
                Icon(Icons.star, color: Colors.yellow, size: 40,),

              ],

            ),

            SizedBox(height: 15,),

            Text("Taken from PLACEHOLDER reviews", style: TextStyle(
                color: Colors.white
            ),),

            SizedBox(height: 25,),

            ElevatedButton(onPressed: (){

            }, child:Text("Add Review"))

          ],
        ),
      ),
    );
  }
}





class HomePage extends StatefulWidget {
  int? index;
  HomePage({int? index, super.key}){
    this.index = index;
  }

  @override
  State<HomePage> createState() => _HomePageState(index??=0);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  int currentIndex;

  _HomePageState(this.currentIndex);

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


  List<Widget> generatedLists(){
    List<Widget> widgetList = [];
    lists.forEach((element) {
      widgetList.add(
        Card(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ListTile(title: Text(element.name, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Text("${element.medias.length} Medias",), onTap: (){
            selectedIndex = lists.indexOf(element);
            Navigator.of(context).pushNamed('singleList');
          },
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        ElevatedButton(onPressed: (){
          Navigator.of(context).pushNamed("listCreate");
        }, child: Text("Add List")),
        Column(children: generatedLists())
      ],),
    );
  }
}

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
                    element.check();
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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: TextField(controller: searchController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), fillColor: Colors.white, hintText: "Find anything!", filled: true, hintStyle: TextStyle(color: Colors.grey)), style: TextStyle(color: Colors.black),),
              ),
              IconButton(onPressed: () async{
                String search = searchController.text;
                searchedList = [];
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
              }, icon: Icon(Icons.search))
            ],
          ),
        ),
        Expanded(child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 350,
            child: ListView.builder(itemCount: searchedList.length, shrinkWrap: true, itemBuilder: (context, index){
              return Card(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(title: Text(searchedList[index].title, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(searchedList[index].year),
                    Text(searchedList[index].mediaType)
                  ],
                ), onTap: (){
                  showModalBottomSheet(context: context, builder: (BuildContext context){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 500,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: listButtons(searchedList[index], context),
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
      globalLists.add(Image.network(selected.poster, width: 200));
    }
    for (var element in lists) {
      globalLists.add(
          ElevatedButton(onPressed: (){
            if(element.medias.where((element) => element.title==selected.title).isEmpty){
              setState(() {
                element.medias.add(selected);
              });
            }
            Navigator.pop(context);
          }, child: Text(element.name))
      );
    }
    return globalLists;
  }
}

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
            }, child: Text("add list"))
          ],
        ),
      )
    );
  }
}










