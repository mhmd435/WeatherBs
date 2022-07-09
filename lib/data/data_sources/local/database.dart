import 'dart:async';
import 'package:floor/floor.dart';
import 'package:weatherBs/data/data_sources/local/city_dao.dart';

import '../../../domain/Models/city_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}