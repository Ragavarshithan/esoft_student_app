import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget performanceDialog(BuildContext context,bool isGood) {
  return AlertDialog(
    icon: CircleAvatar(
      backgroundColor: isGood ?Colors.green.shade100 : Colors.red.shade100,
      radius: 50,
      child: Icon(
          isGood ? Icons.emoji_events : Icons.trending_down,
        size: 60,
        color: isGood ? Colors.green : Colors.red.shade700,
      ),
    ),
    title:  Text(
        isGood ? "Great Job!" : "Performance Alert",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isGood ? Colors.green : Colors.red.shade700,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children:  [
        Text( isGood ? "Your performance is good." : "Your performance is currently low.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        SizedBox(height: 8),
        Text(isGood ? "keep up the great work and continue achieving more!" : "We noticed you may be facing some challenges.\n We recommend you to meet your lecturer for guidance ",textAlign: TextAlign.center,),
      ],
    ),
    actions: [
      Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(isGood ? Colors.green.shade600 : Colors.red.shade700),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            fixedSize: WidgetStatePropertyAll(
              Size.fromHeight(52),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child:  Text(isGood ? "Keep it up!" : "please Meet your lecturer",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16,fontWeight: FontWeight.bold),),
        ),
      ),
    ],
  );
}