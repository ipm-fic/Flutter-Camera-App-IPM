import 'package:flutter_device_type/flutter_device_type.dart';

double fontSize(){
    if (Device.get().isTablet){
      return 35;
    } else {
      return 20;
    }
}

double fontSizeCamera(){
  if (Device.get().isTablet){
    return 25;
  } else {
    return 15;
  }
}

double buttonSize(){
  if (Device.get().isTablet){
    return 50;
  } else {
    return 30;
  }
}

double buttonSizeToggle(){
  if (Device.get().isTablet){
    return 50;
  } else {
    return 26;
  }
}

double appBarHeight(){
  if(Device.get().isTablet){
    return 80;
  } else{
    return 40;
  }
}

double heightButton(){
  if(Device.get().isTablet){
    return 100;
  } else {
    return 50;
  }
}

double widthButton(){
  if(Device.get().isTablet){
    return 100;
  } else {
    return 50;
  }
}

double rowHeight(){
  if(Device.get().isTablet){
    return 150;
  } else{
    return 100;
  }
}

double buttonSizeGallery(){
  if (Device.get().isTablet){
    return 80;
  } else {
    return 30;
  }
}

double buttonSizeLoading(){
  if (Device.get().isTablet){
    return 150;
  } else {
    return 80;
  }
}
