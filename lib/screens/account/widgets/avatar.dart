import 'package:flutter/material.dart';

class AvatarAccount extends StatelessWidget {
  final String photoUrl;

  const AvatarAccount({Key key, this.photoUrl,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: Colors.blue[200])
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue[700],
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl != null? null : Icon(Icons.camera_enhance, color: Colors.white,) ,
      ),
    );
  }
}
