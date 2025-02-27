import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:movies_app/Models/id_model.dart';
import 'package:movies_app/Models/movie_model.dart';
import 'package:movies_app/Models/search_model.dart';
import 'package:movies_app/Modules/Movie%20Details/movie_details.dart';
import 'package:movies_app/Modules/all_movies/all_movies.dart';
import 'package:movies_app/Services/movies_services.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import 'package:movies_app/Shared/Styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieDataModel> movies = [] ;
  List<MovieDataModel> forYouMovies = [] ;
  List<MovieDataModel> popularMovies = [] ;

  Future <void> getData()async{
    List<MovieDataModel> res = await MoviesServices().getData();
    setState(() {
      movies = res ;
    });

    List<MovieDataModel> res1 = await MoviesServices().getForYouData();
    setState(() {
      forYouMovies = res1 ;
    });

    List<MovieDataModel> res2 = await MoviesServices().getPopularData()
    ;
    setState(() {
      popularMovies = res2 ;
    });
  }

  var boardController = PageController() ;
  int num = 0 ;

  Map<String, dynamic> userMap = {};


  Future<void> addToFavorites({
    required averageRating,
    required id,
    required primaryImage,
    required primaryTitle,
    required startYear,
    required endYear,
    required description,
    required contentRating,
    required numVotes,
    required type,
    required runtimeMinutes,
    required genres,
})async {
    SearchModel model = SearchModel(
        averageRating: averageRating,
        id: id,
        primaryImage: primaryImage,
        primaryTitle: primaryTitle,
        startYear : startYear,
        endYear : endYear,
        description : description,
        contentRating : contentRating,
        numVotes : numVotes,
        type : type,
        runtimeMinutes : runtimeMinutes,
        genres : genres,
    );
    FirebaseFirestore
        .instance
        .collection('likes')
        .doc(id)
        .set(model.toMap())
        .then((value) async {
           await main();
           setState(() {
        showToast(text: 'Movie Added successfully', backgroundColor: Colors.green);
             });
            if (kDebugMode) {
              print('data added successfully');
            }
    })
        .catchError((error){
          if (kDebugMode) {
            print(error.toString());

          }});

    FirebaseFirestore
        .instance
        .collection('likesId')
        .doc(id)
        .set({'id':id})
        .then((value) async {
      if (kDebugMode) {
        print('data added successfully');
      }
    })
        .catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }});
  }


 Future<void> deleteFromFavorites({
    required id,
  })async {
    FirebaseFirestore
        .instance
        .collection('likes')
        .doc(id)
        .delete()
        .then((value){
          if (kDebugMode) {
        print('data deleted successfully');
      }
    })
        .catchError((error){
      if (kDebugMode) {
        print(error.toString());

      }});

    FirebaseFirestore
        .instance
        .collection('likesId')
        .doc(id)
        .delete()
        .then((value) async {
        setState(() {
          userMap.remove('key $id');
        if (kDebugMode) {
          print('userMap');
          print(userMap);
        }
        showToast(text: 'Movie Deleted successfully', backgroundColor: Colors.red);
      });
      if (kDebugMode) {
        print('data deleted successfully');
      }
    })
        .catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }});
  }

  List<Model> data = [] ;

  Future<void> main()async {
     await FirebaseFirestore
        .instance
        .collection('likesId')
        .get()
        .then((value){
          for (var action in value.docs) {
            setState(() {
              data.add(Model.fromJson(action.data()));
            });
          }
          if (kDebugMode) {
            print('data[1].id');
            print(data[1].id);
          }
    })
        .catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }});

    if(data.isNotEmpty){
      for (int i = 0; i < data.length; i++) {
        setState(() {
          userMap['key ${data[i].id!}'] = true;
        });
      }
      if (kDebugMode) {
        print('userMap');
        print(userMap);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    main();
  }
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: movies.isNotEmpty,
        builder: (context) => RefreshIndicator(
          onRefresh: () {
            return getData();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65 ,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      PageView.builder(
                        onPageChanged: (int index){
                          setState(() {
                            num = index ;
                          });
                        },
                        itemBuilder:(context,index) => pageView(movies[num].primaryImage),
                        controller: boardController,
                        itemCount: movies.length,
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.32,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.darkColor.withOpacity(0.1),
                                  MyColors.darkColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                          ),
                          child:Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children:[
                                      Container(
                                          height: 16.0 ,
                                          width: 30.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0)
                                          ),
                                          child: const Image(
                                            image: AssetImage('assets/images/imdp.jpg') ,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text('${movies[num].averageRating}' , style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0),)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  '${movies[num].primaryTitle}',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Row(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: const EdgeInsetsDirectional.symmetric(vertical: 10.0 , horizontal: 30.0),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                MyColors.primaryColor.withOpacity(0.8),
                                                CupertinoColors.activeBlue
                                              ]
                                          ),
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      child: const Text(
                                        'Watch Now',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0,),
                                    GestureDetector(
                                      onTap: () async {
                                        if(userMap['key ${movies[num].id}'] == true){
                                          await deleteFromFavorites(
                                           id: movies[num].id,
                                           );
                                        }else{
                                          await addToFavorites(
                                                averageRating: movies[num].averageRating,
                                                id: movies[num].id,
                                                primaryImage: movies[num].primaryImage,
                                                primaryTitle: movies[num].primaryTitle,
                                                startYear: movies[num].startYear,
                                                endYear: movies[num].endYear,
                                                description: movies[num].description,
                                                contentRating: movies[num].contentRating,
                                                numVotes: movies[num].numVotes,
                                                type: movies[num].type,
                                                runtimeMinutes: movies[num].runtimeMinutes,
                                                genres: movies[num].genres
                                            );
                                        }
                                      },
                                      child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          padding: const EdgeInsetsDirectional.all(5.0),
                                          decoration: BoxDecoration(
                                            color: userMap['key ${movies[num].id}'] == true ? MyColors.primaryColor.withOpacity(0.7) : Colors.grey[700],
                                              borderRadius: BorderRadius.circular(20.0)
                                          ),
                                          child: userMap['key ${movies[num].id}'] == true ?  Icon(IconlyBold.bookmark , color: MyColors.primaryColor,) : const Icon(IconlyLight.bookmark)
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    height: 60.0,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index) => images(movies[index] , index),
                                        separatorBuilder: (context,index) => const SizedBox(width: 10.0,),
                                        itemCount: movies.length
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SmoothPageIndicator(
                                        controller: boardController,
                                        count: movies.length,
                                        effect: SwapEffect(
                                          dotColor: Colors.grey,
                                          dotHeight: 10.0,
                                          dotWidth: 10.0,
                                          spacing: 5.0,
                                          activeDotColor: MyColors.primaryColor,
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Image(image: AssetImage('assets/images/btv.png'), height: 100.0,)
                    ],
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                   child: Column(
                     children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          const Text(
                              'For You',
                            style:  TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: (){
                                        navigateTo(context, AllMovies(allMovies: forYouMovies, num: 0,));
                                      },
                                      child: const Text(
                                          'See All',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600
                                        ),
                                      )
                                  ),
                                ],
                              )
                          )
                        ],
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 5.0),
                         child: SizedBox(
                           height: 180.0,
                           child: ListView.separated(
                             scrollDirection: Axis.horizontal,
                               itemBuilder: (context,index) => forYouItem(forYouMovies[index] , index),
                               separatorBuilder: (context,index) => const SizedBox(width: 10.0,),
                               itemCount: forYouMovies.length
                           ),
                         ),
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children:[
                           const Text(
                             'Popular',
                             style:  TextStyle(
                                 fontSize: 20.0,
                                 fontWeight: FontWeight.w700
                             ),
                           ),
                           Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   TextButton(
                                       onPressed: (){
                                         navigateTo(context, AllMovies(allMovies: popularMovies, num: 1,));
                                       },
                                       child: const Text(
                                         'See All',
                                         style: TextStyle(
                                             fontSize: 16.0,
                                             fontWeight: FontWeight.w600
                                         ),
                                       )
                                   ),
                                 ],
                               )
                           )
                         ],
                       ),
                       Container(
                         color: MyColors.darkColor,
                         child: GridView.count(
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         crossAxisCount: 2,
                         mainAxisSpacing: 10.0,
                         crossAxisSpacing: 10.0,
                         childAspectRatio: 1 / 1.5,
                         children: List.generate(
                           popularMovies.length,(index) => gridBuilder(popularMovies[index] , index),
                       ),
                     ),
                    )
                     ],
                   ),
                 ),
              ],
            ),
          ),
        ),
        fallback: (context) => Center(child: CircularProgressIndicator(color: MyColors.primaryColor,))
    );
  }
  Widget images(MovieDataModel model , index) => GestureDetector(
    onTap: (){
      setState(() {
        num = index ;
      });
    },
    child: Container(
      width: 100.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: CachedNetworkImage(
            imageUrl: model.primaryImage!,
            fit: BoxFit.cover,
            width: 50.0,
            errorWidget: (context,url,error) => const Icon(Icons.error , color: Colors.red,),
      ),
    ),
  );

  Widget pageView(url) =>Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )
    ),
    child: CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context,url,error) => const Icon(Icons.error , color: Colors.red,),
    ),
  );

  Widget forYouItem(MovieDataModel model , index) => GestureDetector(
    onTap: (){
      navigateTo(context, MovieDetailsScreen(index: index+1, id: model.id!,type: model.type!,genre: model.genres![0],));
    },
    child: Container(
      height: 180.0,
      width: 100.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          CachedNetworkImage(
            imageUrl: model.primaryImage!,
            fit: BoxFit.cover,
            height: 180.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.18,
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:  const EdgeInsetsDirectional.only(start: 3.0),
                    child: Container(
                        height: 12.0 ,
                        width: 25.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0)
                        ),
                        child: const Image(
                          image: AssetImage('assets/images/imdp.jpg') ,
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Text('${model.averageRating}' , style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0),)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );

  Widget gridBuilder(MovieDataModel model , index) => GestureDetector(
    onTap: (){
      navigateTo(context, MovieDetailsScreen(index: index+1, id: model.id!,type: model.type!,genre: model.genres![0],));
    },
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: MyColors.solidDarkColor
      ),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          CachedNetworkImage(
            imageUrl: model.primaryImage!,
            fit: BoxFit.cover,
            height: 300.0,
            width: 200.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.18,
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:  const EdgeInsetsDirectional.only(start: 3.0),
                    child: Container(
                        height: 12.0 ,
                        width: 25.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0)
                        ),
                        child: const Image(
                          image: AssetImage('assets/images/imdp.jpg') ,
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Text('${model.averageRating}' , style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0),)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

