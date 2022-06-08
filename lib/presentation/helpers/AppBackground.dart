
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppBackground{

  static AssetImage getBackGroundImage(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk').format(now);
    if(6 > int.parse(formattedDate)){
      return AssetImage('images/pic_bg.jpg');
    }else if(18 > int.parse(formattedDate)){
      return AssetImage('images/pic_bg.jpg');
    }else{
      return AssetImage('images/pic_bg.jpg');
    }
  }

}