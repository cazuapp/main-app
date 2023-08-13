
import 'dart:developer';
import 'dart:io';

class AppInstance {

  static final AppInstance instance = AppInstance.build();

  factory AppInstance() 
  {
      return instance;
  }

 Future<void> setup() async {
    log("Running setup..");
  }


}