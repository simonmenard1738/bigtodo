import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


///
/// Make sure to add this code in your yaml file under cupertino_icons
///   sqflite: ^2.0.0+4
///   path_provider: any
///


class Mydb {
  late Database db;

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bigTodo.db');
    print("Database path:" + path);

    db = await openDatabase(
      path,
      version: 7,
      onCreate: (Database db, int version) async {
        await _createDatabase(db, version);
      },
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      create table if not exists User(
        user_id integer primary key autoincrement,
        username varchar,
        email varchar,
        password varchar
      );
      
      create table if not exists Media(
        media_id integer primary key autoincrement,
        title varchar,
        year varchar,
        mediaType varchar,
        checked int
      );

      create table if not exists UserList(
        user_list_id integer primary key autoincrement,
        name varchar,
        user_id integer
      );

      create table if not exists List_Media(
        list_media_id integer primary key autoincrement,
        user_list_id integer,
        media_id integer
      );
    ''');
  }


  ///
  /// Get Functions
  ///


  Future<Map<dynamic, dynamic>?> getUser(int user_id) async {
    List<Map> maps = await db.query('User', where: 'user_id = ?', whereArgs: [user_id]);

    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> getMedia(int media_id) async {
    List<Map> maps =
    await db.query('Media', where: 'media_id = ?', whereArgs: [media_id]);

    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> getUserList(int user_id) async {
    List<Map> maps =
    await db.query('UserList', where: 'user_id = ?', whereArgs: [user_id]);

    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }
  Future<Map<dynamic, dynamic>?> getList_Media(int list_media_id) async {
    List<Map> maps =
    await db.query('List_Media', where: 'list_media_id = ?', whereArgs: [list_media_id]);

    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }


  ///
  /// Insert Functions
  ///


  Future<void> insertUser(String username, String email, String password) async {
  db.rawInsert("insert into User (username, email, password) values (?,?,?);",

    [
      username,
      email,
      password
    ]
  );
   
  }


  Future<bool> checkUserCredentials(String username, String password) async {
    //final Database db = await db;

    List<Map<String, dynamic>> result = await db.query(
      'User',
      where: 'username = ? and password = ?', // Corrected the use of "where" keyword
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }




  void insertMedia(String title, String year, String mediaType, int checked){
  db.rawInsert("insert into Media (title, year, mediaType,checked) values (?, ?, ?,?);",
      [
        title,
        year,
        mediaType,
        checked,
      ]);
  }


  ///
 /// Delete Functions
 ///

  void deleteList(int list_id) {
    db.rawDelete("DELETE FROM UserList WHERE user_list_id = ?", [list_id]);
  }



  // Future<bool> checkUserCredentials(String username, String password) async {
  //   //final Database db = await database;
  //
  //   List<Map<String, dynamic>> result = await db.rawQuery("select * from User where 'username' = ? and 'password' = ?",
  //   [
  //     username,
  //     password
  //   ]);
  //
  //   return result.isNotEmpty;
  // }




}
