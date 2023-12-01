import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


///
/// Make sure to add this code in your yaml file under cupertino_icons
///   sqflite: ^2.0.0+4
///   path_provider: any
///


class Mydb {
  late Database db; // open the database for storing the data

  Future open() async {
    // get a location using getDatabasepath

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bigTodo.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
        });
    await db.execute('''
         
      create table if not exists Media(
      media_id integer primary key autoincrement,
      title varchar,
      year varchar,
      mediaType varchar,
      checked int
      );
      
      create table if not exists User(
      user_id integer primary key autoincrement,
      username varchar,
      email varchar,
      password varchar
      );
      
      create table if not exists UserList(
      user_list_id integer primary key autoincrement,
      name varchar,
      user_id integer,
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
    List<Map> maps =
    await db.query('User', where: 'user_id = ?', whereArgs: [user_id]);

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


  void insertUser (String username, String email, String password){
    db.rawInsert( "insert into User (username, email,password) values (?, ?, ?);",
        [
          username,
          email,
          password
        ]);
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

  void deleteList(int list_id){
  db.rawDelete("DELETE FROM ");
  }


}
