import 'package:flutter/material.dart';
import 'package:movies_app/Modules/%20Sign_Up/sign_up.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import 'package:movies_app/Shared/Styles/colors.dart';

import '../Login Page/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkColor,
      body:SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Stack(
            children:[
              const Image(image: AssetImage('assets/images/login.jpg') , fit: BoxFit.cover,),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors:[
                          MyColors.darkColor.withOpacity(0.6) ,
                          Colors.black,
                        ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(image: AssetImage('assets/images/btv.png') , height: 200.0,),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 60.0),
                          child: SizedBox(
                            width: 250.0,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                  text: 'Start Streaming Now With ',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                    fontWeight: FontWeight.w500
                                  ),
                                  children: [
                                    TextSpan(
                                        text: 'Black Tv',
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                        ),
                        items(3 , 'Log in' , (){
                          Navigator.push(context, MaterialPageRoute(builder:(ctx) => const LoginPage()));
                        }),
                        items(0 , 'Log in via Apple', (){}),
                        items(1 , 'Log in via Google', (){}),
                        const SizedBox(height: 20.0,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  MyColors.primaryColor,
                                  Colors.blue
                                ]
                            ),
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: MaterialButton(
                            onPressed: (){
                              navigateTo(context, const SignUp());
                            },
                            child: const Text(
                                  'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  Widget items(type,text,method) => GestureDetector(
    onTap: (){
      method();
    },
    child: Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: MyColors.solidDarkColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: MyColors.primaryColor.withOpacity(0.9),
            width: 1.0,
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            if(type==1)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 15.0),
              child: Image(image: AssetImage('assets/images/google.png'),height: 30.0,),
            ),
            if(type==0)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 15.0),
              child: Icon(Icons.apple , color: Colors.white, size: 30.0,),
            ) ,
            Text(text , style: const TextStyle(
              color: Colors.white,
              fontSize: 19.0,
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
    ),
  );
}
