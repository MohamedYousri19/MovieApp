import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Modules/Edit_Profile/Edit_Profile.dart';
import 'package:movies_app/Modules/Main%20Page/main_page.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import 'package:movies_app/Shared/Styles/colors.dart';
import '../../Models/social_user_model.dart';
import '../../Network/Local/Cache_Helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserDataModel? model;
  void getUserData()async{
    FirebaseFirestore.instance
        .collection('users')
        .doc(CachHelper.getData(key:'uId'))
        .get()
        .then((value) {
      setState(() {
        model = UserDataModel.fromJson(value.data()!);
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConditionalBuilder(
            condition: model != null,
            builder: (context) => Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                              CachedNetworkImageProvider(model!.image!),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          model!.email!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(color: Colors.grey, width: 1.0),
                              bottom:
                                  BorderSide(color: Colors.grey, width: 1.0),
                              right: BorderSide(color: Colors.grey, width: 1.0),
                              left: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            'ID: ${model!.uId!}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: MyColors.solidDarkColor,
                            border: const Border(
                              top: BorderSide(color: Colors.grey, width: 1.0),
                              bottom: BorderSide(color: Colors.grey, width: 1.0),
                              right: BorderSide(color: Colors.grey, width: 1.0),
                              left: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            children: [
                              items('assets/images/icon.png', 'Edit Profile', (){navigateTo(context, EditProfileScreen(model: model!,));}),
                              items('assets/images/icon2.png', 'Settings' , (){}),
                              items('assets/images/icon3.png', 'Help Center',  (){}),
                              items('assets/images/icon5.png', 'About BTV' , (){}),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(color: Colors.blue, width: 1.0),
                              bottom: BorderSide(color: Colors.blue, width: 1.0),
                              right: BorderSide(color: Colors.blue, width: 1.0),
                              left: BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            borderRadius: BorderRadius.circular(13.0),
                            color: MyColors.solidDarkColor,
                          ),
                          child: MaterialButton(
                            height: 50.0,
                            onPressed: () async{
                              setState(() {
                                FirebaseAuth.instance.signOut();
                                CachHelper.removeData(key:'uId');
                                navigateAndFinish(context, const MainPage());
                              });
                            },
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator())));
  }
}

Widget items(url, name , method) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: (){
          method();
        },
        child: Column(
            children: [
          Row(
              children: [
            Image(
              image: AssetImage(url),
              height: 50.0,
              width: 50.0,
            ),
            Expanded(child: Text(name)),
            const SizedBox(
              width: 10.0,
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ]),
          if (name != 'About BTV')
            line(),
        ]),
      ),
    );
