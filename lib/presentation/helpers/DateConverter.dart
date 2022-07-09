
import 'package:intl/intl.dart';

class DateConverter{

  /// change dt to our dateFormat ---Jun 23--- for Example
  static dynamic changeDtToDateTime(dt){
    final formatter = DateFormat.MMMd();
    var result = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
        dt * 1000,
        isUtc: true));

    return result;
  }

  /// change dt to our dateFormat ---5:55 AM/PM--- for Example
  static dynamic changeDtToDateTimeHour(dt, timeZone){
    final formatter = DateFormat.jm();
    return formatter.format(
        new DateTime.fromMillisecondsSinceEpoch(
            (dt * 1000) +
                timeZone * 1000,
            isUtc: true));;
  }


}