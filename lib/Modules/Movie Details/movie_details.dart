import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:movies_app/Models/movie_details.dart';
import 'package:movies_app/Modules/Actors%20Screen/actors_screen.dart';
import 'package:movies_app/Services/movie_details_service.dart';
import '../../Models/id_model.dart';
import '../../Models/search_model.dart';
import '../../Models/types_model.dart';
import '../../Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int index ;
  final String id ;
  final String type ;
  final String genre ;

  const MovieDetailsScreen({super.key,required this.index, required this.id, required this.type, required this.genre});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetailsScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

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

  TypesModel? model;
  List<ResultModel> resultList = [];

  void getTypes()async{
    TypesModel res = await MovieDetailsService().getTypeData(type:widget.type, genre:widget.genre,rows: 25);
    setState(() {
      model = res ;
      for(var i = 0 ; i < res.results!.length ; i++){
        if(res.results![i].primaryImage != null && res.results![i].averageRating != null){
          resultList.add(res.results![i]);
        }
      }
    });
  }
  AllMovieDataModel? allMovieDataModel ;

  Future<void> getData() async {
    AllMovieDataModel res = await MovieDetailsService().getAllMovieData(widget.id) ;
    setState(() {
      allMovieDataModel = res ;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    main();
    _tabController = TabController(length: 3, vsync: this);
    getTypes();
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConditionalBuilder(
          condition: resultList.isNotEmpty && allMovieDataModel != null ,
          builder: (context) => Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: allMovieDataModel!.primaryImage!,
                        fit: BoxFit.cover,
                        errorWidget: (context,url,error) => const Icon(Icons.error , color: Colors.red,),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
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
                                    Text('${allMovieDataModel!.averageRating}' , style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0 , horizontal: 15.0) ,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          color: MyColors.solidDarkColor,
                                          border: const Border(
                                            top: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            left: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${allMovieDataModel!.startYear}',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0 , horizontal: 15.0) ,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          color: MyColors.solidDarkColor,
                                          border: const Border(
                                            top: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            left: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${allMovieDataModel!.spokenLanguages![0]}',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0 , horizontal: 15.0) ,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          color: MyColors.solidDarkColor,
                                          border: const Border(
                                            top: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            left: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.blue
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${allMovieDataModel!.countriesOfOrigin![0]}',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${allMovieDataModel!.primaryTitle}',
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
                                      if(userMap['key ${allMovieDataModel!.id}'] == true){
                                        await deleteFromFavorites(
                                          id: allMovieDataModel!.id,
                                        );
                                      }else{
                                        await addToFavorites(
                                            averageRating: allMovieDataModel!.averageRating,
                                            id: allMovieDataModel!.id,
                                            primaryImage: allMovieDataModel!.primaryImage,
                                            primaryTitle: allMovieDataModel!.primaryTitle,
                                            startYear: allMovieDataModel!.startYear,
                                            endYear: allMovieDataModel!.endYear,
                                            description: allMovieDataModel!.description,
                                            contentRating: allMovieDataModel!.contentRating,
                                            numVotes: allMovieDataModel!.numVotes,
                                            type: allMovieDataModel!.type,
                                            runtimeMinutes: allMovieDataModel!.runtimeMinutes,
                                            genres: allMovieDataModel!.genres
                                        );
                                      }
                                    },
                                    child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        padding: const EdgeInsetsDirectional.all(5.0),
                                        decoration: BoxDecoration(
                                            color: userMap['key ${allMovieDataModel!.id}'] == true ? MyColors.primaryColor.withOpacity(0.7) : Colors.grey[700],
                                            borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: userMap['key ${allMovieDataModel!.id}'] == true ?  Icon(IconlyBold.bookmark , color: MyColors.primaryColor,) : const Icon(IconlyLight.bookmark)
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0 , horizontal: 15.0),
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                            color: Colors.white,
                            onPressed: (){
                          Navigator.pop(context) ;
                        }, icon: const Icon(CupertinoIcons.back)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'PG-${widget.index}  -  ${allMovieDataModel!.startYear}',
                        style: const TextStyle(fontSize: 16.0 , fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        '${allMovieDataModel!.description}',
                        style: TextStyle(fontSize: 15.0 , height: 1 , color: Colors.grey[400]),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10.0,),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1 , color: Colors.grey)
                          )
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          indicator: const ShapeDecoration(
                            shape: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3,
                              ),
                            ),
                          ),
                          labelStyle: const TextStyle(fontSize: 15.0 , fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(text: "More Like This"),
                            Tab(text: "About"),
                            Tab(text: "Actors"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              color: MyColors.darkColor,
                              child: GridView.count(
                                padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 10.0),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1 / 1.5,
                                children: List.generate(
                                  resultList.length,(index) => gridBuilder(resultList[index] , index),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Audio Track' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text(
                                            allMovieDataModel!.language != null ?
                                            '${allMovieDataModel!.language}' : 'English'
                                            , style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Subtitles' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text(
                                            allMovieDataModel!.language != null ?
                                            '${allMovieDataModel!.language}' : 'English'
                                            , style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Country' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text(
                                            '${allMovieDataModel!.countriesOfOrigin![0]}',style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Year' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text('${allMovieDataModel!.startYear}', style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Type' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text(
                                            '${allMovieDataModel!.type?.toUpperCase()}',style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('AverageRating' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.0),),
                                          const SizedBox(height: 5.0,),
                                          Text('${allMovieDataModel!.averageRating}', style: const TextStyle(fontSize: 16.0 , color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              color: MyColors.darkColor,
                              child: ListView.builder(
                                  itemBuilder: (context,index) => gridActorBuilder(allMovieDataModel!.cast[index] , allMovieDataModel!.description),
                                  itemCount: allMovieDataModel!.cast.length
                              )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()) ,
      )
    );
  }
  Widget gridBuilder(ResultModel model ,index ) => GestureDetector(
    onTap: (){
      navigateTo(context, MovieDetailsScreen(index: index, id: model.id!, type: model.type!, genre: model.genres![0]));
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
            imageUrl: '${model.primaryImage}',
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
                  Text('${model.averageRating!}' , style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0),)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
  Widget gridActorBuilder(CastDataModel model , description) => ConditionalBuilder(
      condition: model.id != null && model.characters!.isNotEmpty && model.job != null && model.fullName != null,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: (){
            navigateTo(context, ActorsScreen(id:model.id!, description:description!,));
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border(
                  top: BorderSide(
                      width: 2.0,
                      color: MyColors.primaryColor
                  ),
                  bottom: BorderSide(
                      width: 2.0,
                      color: MyColors.primaryColor
                  ),
                  left: BorderSide(
                      width: 2.0,
                      color: MyColors.primaryColor
                  ),
                  right: BorderSide(
                      width: 2.0,
                      color: MyColors.primaryColor
                  ),
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${model.fullName} (${model.characters![0]})' , overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
        ),
      ) ,
      fallback: (context) => Container() ,
  );
}
