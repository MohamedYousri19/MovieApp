import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Styles/colors.dart';

Widget defaultTextField({
  TextEditingController? titleController ,
  String? hintText ,
  String? labelText ,
  required Function valdate,
  IconData? prefixIcon ,
  IconButton? suffixIconIcon ,
  Function? submit ,
  Function? onChange ,
  Function? pressedIcon ,
  required bool isShow ,
  required TextInputType type,
}) =>  SizedBox(
  height: 55.0,
  child: TextFormField(
    onFieldSubmitted: (value){
      submit!(value);
    },
    validator: (s){
      return valdate(s);
    },
    controller: titleController,
    keyboardType: type,
    obscureText: isShow,
    decoration: InputDecoration(
      filled: true,
      fillColor: MyColors.solidDarkColor.withOpacity(0.7),
      hintText: hintText,
      labelStyle: const TextStyle(
        color: Colors.white
      ),
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13.0),
        borderSide: const BorderSide(color: Colors.grey),
         ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.4,
          ),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: MyColors.primaryColor,
            width: 2,
          ),
      ),
      prefixIcon: Icon(prefixIcon , color: Colors.white,),
      suffixIcon: suffixIconIcon,
    ),
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w400
    ),
  ),
);

Widget line() => Padding(
  padding: const EdgeInsets.only(left: 20.0),
  child: Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey,
  )
);

void navigateTo(context , widget) => Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => widget
    ),
);
void navigateAndFinish(context,widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(
    builder: (context) => widget
), (route) => false) ;

Widget defaultButton({
  required Function function,
  required String name,
  double width = double.infinity,
  double radius = 13.0,
  Color backgroundColor = Colors.blue ,
  EdgeInsets? padding ,
}) => Container(
  width: width,
  clipBehavior:Clip.antiAlias ,
  padding: padding,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: backgroundColor,
  ),
  child: MaterialButton(
    height: 50.0,
      onPressed: (){
        function() ;
      },
    child: Text(name , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16.0),),
  ),
);

  Widget defaultTextButton({
    required String text,
    required Function pressed,
    Color? color ,
  }) => TextButton(
      onPressed: (){pressed();}
      , child: Text(text,style: TextStyle(color: color , fontWeight: FontWeight.bold),),
  );

void showToast({
  required String text,
  required Color backgroundColor,
}){
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

