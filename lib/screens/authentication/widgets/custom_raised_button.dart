import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRaiseButton extends StatelessWidget {
  CustomRaiseButton({
    this.text,
    this.assetName,
    this.color,
    this.textColor,
    this.assetColor,
    this.borderRadius,
    this.onPressed,
  });

  final String text;
  final String assetName;
  final Color assetColor;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            assetName == null
                ? SizedBox(
                    width: 50,
                  )
                : SvgPicture.asset(
                    assetName,
                    color: assetColor,
                    width: 30,
                    height: 30,
                  ),
            Text(
              text,
              style: TextStyle(color: textColor),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
