import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:movies_app/Models/social_user_model.dart';
import 'package:movies_app/Modules/Account%20Screen/account_screen.dart';
import 'package:movies_app/Modules/Favorites%20Screen/favorites_screen.dart';
import 'package:movies_app/Modules/Home%20Screen/home_screen.dart';
import 'package:movies_app/Modules/Search%20Screen/search_screen.dart';
import 'package:movies_app/Network/Local/Cache_Helper.dart';
import 'package:movies_app/Shared/Styles/colors.dart';

class TabsLayout extends StatefulWidget {
  const TabsLayout({super.key});

  @override
  State<TabsLayout> createState() => _TabsLayoutState();
}

class _TabsLayoutState extends State<TabsLayout> {
  UserDataModel? model ;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  int selectIndex = 0 ;
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const AccountScreen(),
  ];

  void getUserData()async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CachHelper.getData(key: 'uId'))
        .get()
        .then((value){
          setState(() {
            model = UserDataModel.fromJson(value.data()!);
          });
    })
        .catchError((error){
          if (kDebugMode) {
            print(error.toString());
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: model != null ,
        builder: (context) => Scaffold(
          extendBody: true,
          body: screens[selectIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
              child: Container(
                height: 68.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  )
                ),
                child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    currentIndex: selectIndex,
                    onTap: (index){
                      setState(() {
                        selectIndex = index ;
                        if (kDebugMode) {
                          print(selectIndex);
                        }
                      });
                    },
                    items:  [
                       BottomNavigationBarItem(icon: selectIndex == 0 ? const Icon(IconlyBold.home) :  const Icon(IconlyLight.home) , label: 'Home'),
                       BottomNavigationBarItem(icon:selectIndex == 1 ? const Icon(IconlyBold.search) :  const Icon(IconlyLight.search) , label: 'Search'),
                       BottomNavigationBarItem(icon: selectIndex == 2 ? const Icon(IconlyBold.bookmark) :  const Icon(IconlyLight.bookmark) ,label: 'Favorites'),
                       BottomNavigationBarItem(
                        icon: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(model!.image!),
                              radius: 14.0,
                            )
                          ],
                        )
                        ,
                        label: 'Account',
                      ),
                    ]
                ),
              ),
          )
        ),
        fallback: (context) => Center(child: CircularProgressIndicator(color: MyColors.primaryColor,))
    );
  }
}
