import 'package:flutter_device_type/flutter_device_type.dart';

adaptView(tablet, phone){
  if(Device.get().isTablet){
    return tablet;
  } else {
    return phone;
  }
}
