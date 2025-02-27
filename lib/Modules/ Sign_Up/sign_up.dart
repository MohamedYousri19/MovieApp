import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/social_user_model.dart';
import 'package:movies_app/Network/Local/Cache_Helper.dart';
import '../../Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';
import '../Login Page/login_page.dart';

class SignUp extends StatefulWidget {

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShow = true ;
  bool isShow1 = true ;
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController() ;
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  var firstNameController = TextEditingController() ;
  var secondNameController = TextEditingController() ;
  //
  void createUser(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).then((value){
      CachHelper.saveData(key: 'uId', value: value.user!.uid);
      saveData(uId: value.user!.uid);
      if (kDebugMode){
        print('user created successfully');
      }
    }).catchError((onError){
      if (kDebugMode) {
        print(onError.toString());
      }
    });
  }

  //
  void saveData ({
    required uId,
}){
    UserDataModel model = UserDataModel(
        email: emailController.text,
        image:'https://cdn-icons-png.flaticon.com/512/149/149071.png',
        username: '${firstNameController.text}${secondNameController.text}',
        uId: uId
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value){
      if (kDebugMode){
        print('data created successfully');
      }
    }).catchError((error){
          if (kDebugMode) {
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
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30.0,),
                              defaultTextField(
                                titleController: firstNameController,
                                  valdate: (String  value){
                                    if(value.isEmpty){
                                      return 'First Name must not to be empty' ;
                                    }
                                  },
                                  isShow: false,
                                  type: TextInputType.text,
                                  prefixIcon: Icons.person,
                                  labelText: 'First Name',
                              ),

                              const SizedBox(height: 10.0,),

                              defaultTextField(
                                  titleController: secondNameController,
                                  valdate: (String  value){
                                    if(value.isEmpty){
                                      return 'Last Name must not to be empty' ;
                                    }
                                  },
                                  isShow: false,
                                  type: TextInputType.text,
                                  prefixIcon: Icons.person,
                                  labelText: 'Last Name'
                              ),
                              const SizedBox(height: 10.0,),

                              defaultTextField(
                                  titleController: emailController,
                                  valdate: (String  value){
                                    if(value.isEmpty){
                                      return 'Email Name must not to be empty' ;
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
                                  valdate: (String  value){
                                    if(value.isEmpty){
                                      return 'First Name must not to be empty' ;
                                    }
                                  },
                                  isShow: isShow1,
                                  type: TextInputType.visiblePassword,
                                  prefixIcon: Icons.lock,
                                  labelText: 'Password',
                                  suffixIconIcon: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          isShow1 = !isShow1 ;
                                        });
                                      },
                                      icon: isShow1 ?
                                      const Icon(Icons.visibility)
                                          :
                                      const Icon(Icons.visibility_off)
                                  )
                              ),
                              const SizedBox(height: 10.0,),
                              defaultTextField(
                                  titleController: passwordConfirmController,
                                  valdate: (String  value){
                                    if(value.isEmpty){
                                      return 'First Name must not to be empty' ;
                                    }
                                  },
                                  isShow: isShow,
                                  type: TextInputType.emailAddress,
                                  prefixIcon: Icons.lock,
                                  labelText: 'Confirm Password',
                                suffixIconIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        isShow = !isShow ;
                                      });
                                    },
                                    icon: const Icon(Icons.remove_red_eye)
                                )
                              ),
                              const SizedBox(height: 10.0,),
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
                                      if(passwordController.text == passwordConfirmController.text){
                                        createUser();
                                      }else{
                                        showToast(
                                            text: 'The password and confirm password must be the same.',
                                            backgroundColor: Colors.red
                                        );
                                      }
                                    }
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
                              ),
                              const SizedBox(height: 20.0,),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        navigateTo(context, const LoginPage());
                                      },
                                      child: Text(
                                        'Log in',
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
