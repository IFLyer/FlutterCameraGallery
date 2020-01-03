import 'package:flutter/foundation.dart';

class GalleryProvider with ChangeNotifier{
  List<String> _list =[];
  List get list => _list;

  addList(String string){
    _list.add(string);
    notifyListeners();
  }
}