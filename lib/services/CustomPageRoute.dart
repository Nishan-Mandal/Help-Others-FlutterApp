import 'package:flutter/material.dart';

class CustomPageRouteAnimation extends PageRouteBuilder {
  final Widget child;
  CustomPageRouteAnimation({this.child})
      : super(
          transitionDuration: Duration(milliseconds: 150),
          reverseTransitionDuration: Duration(milliseconds: 150),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: child,
        // child: ScaleTransition(
        //   scale: animation.drive(Tween(begin: 1.0, end: 1.0)
        //       .chain(CurveTween(curve: Curves.easeOutCubic))),
        //   child: child,
        // ),
      );
  // SlideTransition(
  //   position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
  //       .animate(animation),
  //   child: child,
  // );
}
