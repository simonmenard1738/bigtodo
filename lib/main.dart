import 'package:big_to_do/service.dart';
import 'package:flutter/material.dart';
import 'CreateListPage.dart';
import 'HomePage.dart';
import 'RatingPage.dart';
import 'SearchPage.dart';
import 'SingleListPage.dart';
import 'user.dart';
import 'media.dart';
import 'userlist.dart';
import 'db.dart';
import 'EditProfilePage.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController searchController = TextEditingController();


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


              bool isValidCredentials = await mydb.checkUserCredentials(user, pass);

              if (isValidCredentials) {
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


                Navigator.of(context).pushNamed('homePage');
              }, child: Text("Register"))
            ]
        ),

      ),
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











