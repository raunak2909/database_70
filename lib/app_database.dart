import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDataBase {
  //Singleton
  AppDataBase._();

  static final AppDataBase db = AppDataBase._();

  static final String TABLE_NAME = "note";
  static final String COLUMN_ID = "id";
  static final String COLUMN_TITLE = "title";
  static final String COLUMN_DESC = "desc";

  Database? myDB;

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await initDB();
      return myDB!;
    }
  }

  Future<Database> initDB() async {
    var mDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(mDirectory.path, "noteDb");

    return openDatabase(dbPath, version: 1, onCreate: (db, _) {
      //create your tables here..

      db.execute(
          "Create Table $TABLE_NAME ($COLUMN_ID integer primary key autoincrement, $COLUMN_TITLE text not null, $COLUMN_DESC text not null)");
    });
  }

  Future<bool> addNote(String title, String desc) async {
    Database db = await getDB();

    var count = await db.insert(TABLE_NAME, {
      COLUMN_TITLE: title,
      COLUMN_DESC: desc
    });

    return count>0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async{
    Database db = await getDB();

    var data = await db.query(TABLE_NAME);

    return data;
  }
}
