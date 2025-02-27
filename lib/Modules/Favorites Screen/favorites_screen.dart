import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../Models/id_model.dart';
import '../../Models/search_model.dart';
import '../../Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';
import '../Movie Details/movie_details.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<SearchModel> data = [] ;
  void getData(){
    FirebaseFirestore.instance
        .collection('likes')
        .snapshots()
        .listen((event) {
      data = [] ;
      for (var element in event.docs) {
        data.add(SearchModel.fromJson(element.data()));
      }
    });
  }

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
      await main();
      setState(() {
        userMap['key $id'] = null ;
        if (kDebugMode) {
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


  List<Model> dataID = [] ;

  Future<void> main()async {
    await FirebaseFirestore
        .instance
        .collection('likesId')
        .get()
        .then((value){
      for (var action in value.docs) {
        setState(() {
          dataID.add(Model.fromJson(action.data()));
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

    if(dataID.isNotEmpty){
      for (int i = 0; i < dataID.length; i++) {
        setState(() {
          userMap['key ${dataID[i].id!}'] = true;
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
    return Builder(
      builder: (context) {
        getData();
        return Scaffold(
            appBar: AppBar(
              title: const Text('Favorites'),
            ),
          body:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 30.0),
            child: ConditionalBuilder(
                condition: data.isNotEmpty,
                builder: (context) => Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => videoItem(data[index],index),
                          itemCount: data.length,
                        separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1.0,
                              color: Colors.grey,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            );
                        },),
                    ),
                  ],
                ),
                fallback: (context) => const Center(child: Image(image: AssetImage('assets/images/empty.png') , width: 200.0,))
            ),
          )

        );
      }
    );
  }
  Widget videoItem(SearchModel model,index) => ConditionalBuilder(
    condition: model.primaryImage != null &&
        model.averageRating != null &&
        model.primaryTitle != null &&
        model.description != null &&
        model.type != null,
    builder: (context) => GestureDetector(
      onTap: (){
        navigateTo(context, MovieDetailsScreen(index: index, id: model.id!, type: model.type!, genre: model.genres![0]));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0 , top: 10.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  CachedNetworkImage(
                    imageUrl: model.primaryImage!,
                    fit: BoxFit.cover,
                    height: 180.0,
                    width: 120,
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
                            padding:
                            const EdgeInsetsDirectional.only(start: 3.0),
                            child: Container(
                                height: 12.0,
                                width: 25.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0)),
                                child: const Image(
                                  image: AssetImage('assets/images/imdp.jpg'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${model.averageRating}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.primaryTitle}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      '${model.description}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.type!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(userMap['key ${model.id}'] == true){
                              setState((){
                                deleteFromFavorites(
                                  id: model.id,
                                );
                                main();
                              });
                            }else{
                              setState(() {
                                addToFavorites(
                                    averageRating: model.averageRating,
                                    id: model.id,
                                    primaryImage: model.primaryImage,
                                    primaryTitle: model.primaryTitle,
                                    startYear: model.startYear,
                                    endYear: model.endYear,
                                    description: model.description,
                                    contentRating: model.contentRating,
                                    numVotes: model.numVotes,
                                    type: model.type,
                                    runtimeMinutes: model.runtimeMinutes,
                                    genres: model.genres
                                );
                                main();
                              });
                            }
                          },
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsetsDirectional.all(5.0),
                              decoration: BoxDecoration(
                                  color: userMap['key ${model.id}'] == true ? MyColors.primaryColor.withOpacity(0.7) : Colors.grey[700],
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: userMap['key ${model.id}'] == true ?  Icon(IconlyBold.bookmark , color: MyColors.primaryColor,) : const Icon(IconlyLight.bookmark)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    fallback: (context) => Container(),
  );
}
