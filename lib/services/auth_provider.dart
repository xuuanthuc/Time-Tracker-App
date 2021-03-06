import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/services/auth.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({@required this.auth, @required this.child});
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
  //tao mot phuong thuc cho phep truy cap vao provider cu
 static AuthBase of(BuildContext context){
   AuthProvider provider = context.inheritFromWidgetOfExactType(AuthProvider); //ke thua tu widget cua loat chinh xac
   return provider.auth;
 }
}