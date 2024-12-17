


import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String  title;

  const CustomButton(
      {super.key,
        required this.onTap,
        required this.title,

        });
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        width: 200,
        height: 50,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.yellow, Colors.green])),
        child: InkWell(
          onTap: () => onTap(),
          splashColor: Colors.red,
          customBorder:  CircleBorder(),
          child: Center(
            child: Text(
              title,
              //  color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}