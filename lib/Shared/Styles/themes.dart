import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/Shared/Styles/colors.dart';

ThemeData darkTheme = ThemeData(
    primaryColor: MyColors.primaryColor,
    primaryColorDark: MyColors.primaryColor,
    primaryColorLight: MyColors.primaryColor,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: MyColors.primaryColor,
      onPrimary: MyColors.solidDarkColor,
      secondary: MyColors.darkColor,
      onSecondary: MyColors.primaryColor,
      error: Colors.red,
      onError: Colors.red,
      background: Colors.white12,
      onBackground: Colors.white12,
      surface: Colors.white,
      onSurface: Colors.white,
    ),
    floatingActionButtonTheme:  FloatingActionButtonThemeData(
      backgroundColor: MyColors.primaryColor,
    ),
    scaffoldBackgroundColor: MyColors.darkColor,
    appBarTheme:  AppBarTheme(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: MyColors.darkColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white12,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Urbanist',
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
            color: Colors.white,
            size: 25.0
        )
    ),
    bottomNavigationBarTheme:  BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15.0
      ),
      backgroundColor: Colors.white24,
      unselectedItemColor:Colors.white ,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.primaryColor,
      elevation: 20.0,
    ),
    textTheme:  const TextTheme(
      bodyLarge: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w400,
          color: Colors.white
      ),
      bodyMedium: TextStyle(
          fontSize: 15.0,
          height: 1,
          color: Colors.white
      ),
    ),
    fontFamily: 'Urbanist',
    iconTheme: const IconThemeData(
        color: Colors.white
    )
) ;
