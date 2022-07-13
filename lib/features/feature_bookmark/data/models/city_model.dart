
import 'package:floor/floor.dart';

@entity
class City{

  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;

  City({required this.name});
}