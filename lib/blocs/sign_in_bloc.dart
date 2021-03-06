import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isloadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream =>
      _isloadingController
          .stream; //bien nhan luong, tra ve bo dieu khien luon => luong dau vao cho trinh tao
  void dispose() {
    _isloadingController
        .close(); //dong do dieu khien luong nay khi loading duoc xoa khoi widget va khong can dung no nua
  }

  void _setIsLoading(bool isLoading) =>
      _isloadingController.add(
          isLoading); //them no la bien truc tieps de dong bo hoa vowis controll

  Future<User> signInWithAnonymously() async {
    try {
      _setIsLoading(true);
      return await auth.signInWithAnonymously();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async {
    try{
      _setIsLoading(true);
      return await auth.signInWithGoogle();
    } catch (e){
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInWithFacebook() async{
    try{
      _setIsLoading(true);
      return await auth.signInWithFacebook();
    } catch (e){
      _setIsLoading(false);
      rethrow;
    }
  }
}
