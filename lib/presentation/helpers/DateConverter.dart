
import 'package:intl/intl.dart';

class DateConverter{

  static dynamic changeDtToDateTime(dt){
    final formatter = DateFormat.MMMd();

    // change dt to our dateFormat ---Jun 23--- for Example
    var result = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
        dt * 1000,
        isUtc: true));

    return result;
  }

}