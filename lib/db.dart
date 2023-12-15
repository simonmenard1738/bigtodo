import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';


///
/// Make sure to add this code in your yaml file under cupertino_icons
///   sqflite: ^2.0.0+4
///   path_provider: any
///


class Mydb {
  late Database db;
  int? lastInsertedUserId;
  int? lastInsertedMediaId;

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bigTodo8.db');
    print("Database path:" + path);
    db = await openDatabase(
      path,
      version: 6, // Increment the version number
      onCreate: (Database db, int version) async {
        await _createDatabase(db, version);
      },
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    try {
      await db.execute('''
        create table if not exists Media(
          media_id integer primary key autoincrement,
          title varchar(100),
          year varchar(10),
          mediaType varchar(20),
          checked integer,
          poster varchar(500)
        )
      ''');

      await db.execute('''
            create table if not exists User(
            user_id integer primary key autoincrement,
            username varchar(255),
            email varchar(255),
            password varchar(255)
          )
      ''');

      await db.execute('''
          create table if not exists UserList(
            user_list_id integer primary key autoincrement,
            name varchar(255),
            user_id integer
          )
      ''');

      await db.execute('''
          create table if not exists List_Media(
            list_media_id integer primary key autoincrement,
            user_list_id integer,
            media_id integer
          )
      ''');
    } catch (e) {
      print(e);
    }
  }


  ///
  /// Get Functions
  ///


  Future<User> getUser(int user_id) async {
    List<Map> maps =
    await db.query('User', where: 'user_id = ?', whereArgs: [user_id]);

    if (maps.length > 0) {
      return User(maps.first['username'], maps.first['password']);
    } else {
      return User.empty();
    }
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

  Future<List<Map<dynamic, dynamic>>?> getList_Media(int user_list_id) async {
    List<Map> maps =
    await db.query(
        'List_Media', where: 'user_list_id = ?', whereArgs: [user_list_id]);

    if (maps.length > 0) {
      return maps;
    }
    return null;
  }


  ///
  /// Insert Functions
  ///


  Future<void> insertUser(String username, String email,
      String password) async {
    lastInsertedUserId = await db.rawInsert(
        "insert into User (username, email, password) values (?,?,?);",

        [
          username,
          email,
          password
        ]
    );
  }


  Future<int> checkUserCredentials(String username, String password) async {
    //final Database db = await db;

    List<Map<String, dynamic>> result = await db.query(
      'User',
      where: 'username = ? and password = ?',
      // Corrected the use of "where" keyword
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result[0]['user_id'];
    } else {
      return -1;
    }
  }


  Future<void> insertMedia(String title, String year, String mediaType, int checked, String poster) async{
    lastInsertedMediaId = await db.rawInsert(
        "insert into Media (title, year, mediaType,checked,poster) values (?, ?, ?, ?, ?);",
        [
          title,
          year,
          mediaType,
          checked,
          poster
        ]);
  }

  Future<void> insertUserList(String name, int? user_id) async {
    db.rawInsert("insert into UserList (name, user_id) values (?,?);",

        [
          name,
          user_id,

        ]
    );
  }

  Future<void> insertMediaList(int userList, int? media) async {
    db.rawInsert("insert into List_Media (user_list_id, media_id) values (?,?);",

        [
          userList,
          media,

        ]
    );
  }

    ///
    /// Delete Functions
    ///

    void deleteList(int list_id) {
      db.rawDelete("DELETE FROM ");
    }


  void deleteUserList(int userlistId) async {

      db.delete(
      'UserList',
      where: 'user_list_id = ?',
      whereArgs: [userlistId],
    );
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

    ///
    ///  Update Functions
    ///

    Future<void> updateUser(String newUsername, String newEmail,
        int? userId) async {
      try {
        await db.update(
          'User',
          {
            'username': newUsername,
            'email': newEmail,

          },
          where: 'user_id = ?',
          whereArgs: [userId],
        );

        print('User updated successfully');
      } catch (e) {
        print('Error updating user: $e');
      }
    }

    Future<void> checkMedia(String media_id, int checked) async{
      try{
        await db.update('Media', {'checked': checked}, where: 'media_id = ?', whereArgs: [media_id]);
      }catch(e){
        print("Error checking media id. ${e}");
      }
    }
  }


