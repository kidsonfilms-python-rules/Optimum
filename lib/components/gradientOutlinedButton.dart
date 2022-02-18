import 'package:flutter/material.dart';

// CREDITS TO COPSONROAD (https://stackoverflow.com/users/6618622/copsonroad)
// LINK TO ORIGINAL CODE: https://stackoverflow.com/a/67571367/13946018

class GradientOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final Gradient? gradient;
  final double thickness;

  const GradientOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
    this.gradient,
    this.thickness = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // the cool corner cutoff effect was accidental lol, gonna keep it tho. - ray (2/13/22)
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(15)),
      child: Container(
        color: Colors.black,
        margin: EdgeInsets.all(thickness),
        child: OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        ),
      ),
    );
  }
}