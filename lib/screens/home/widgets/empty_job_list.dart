import 'package:flutter/material.dart';

class EmptyJobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset('assets/images/empty.png'), 
      ),
    );
  }
}
