import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/LayOut/taps_layout.dart';
import 'package:movies_app/Modules/%20Sign_Up/sign_up.dart';
import 'package:movies_app/Network/Local/Cache_Helper.dart';
import 'package:movies_app/Shared/Components/Components.dart';

import '../../Shared/Styles/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController() ;
  var passwordController = TextEditingController() ;
  bool isShow = true ;
  var formKey = GlobalKey<FormState>();

  void signIn(){
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).then((value){
      CachHelper.saveData(key: 'uId', value: value.user!.uid );
      showToast(text: 'Logged in Successfully', backgroundColor: Colors.green);
      navigateTo(context, const TabsLayout());
    }).catchError((error){
      showToast(text: error.toString(), backgroundColor: Colors.red);
      if(kDebugMode){
        print(error.toString());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkColor,
      body:SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Form(
            key: formKey,
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
                      padding: const EdgeInsetsDirectional.only(top: 100.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          const Text(
                            'Log in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30.0,),
                          defaultTextField(
                            titleController: emailController,
                              valdate: (String value){
                                if(value.isEmpty){
                                  return 'email must not be empty';
                                }
                              },
                              isShow: false,
                              type: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            labelText: 'Email'
                          ),
                          const SizedBox(height: 10.0,),
                          defaultTextField(
                            titleController: passwordController,
                              valdate: (String value){
                                if(value.isEmpty){
                                  return 'password must not be empty';
                                }
                              },
                              isShow: isShow,
                              type: TextInputType.visiblePassword,
                              prefixIcon: Icons.lock,
                              suffixIconIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      isShow = !isShow ;
                                    });
                                  },
                                  icon: isShow ?
                                  const Icon(Icons.visibility, color: Colors.white,)
                                      :
                                  const Icon(Icons.visibility_off, color: Colors.white,)
                              ),
                              labelText: 'password'
                          ),
                          const SizedBox(height: 20.0,),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            height: 45.0,
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
                                if(formKey.currentState!.validate()){
                                  signIn();
                                }
                              },
                              child: const Text(
                                    'Log in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          const Text(
                            'Forget The Password?',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                    onPressed: (){
                                      navigateTo(context, const SignUp());
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0 , bottom: 5.0 , right: 0 , left: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.white10
                      ),
                      child: const Icon(Icons.arrow_back_ios , color: Colors.white , size: 30.0,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
