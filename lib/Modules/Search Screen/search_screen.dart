import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/search_model.dart';
import 'package:movies_app/Models/types_model.dart';
import 'package:movies_app/Modules/Filters%20Screen/filters_screen.dart';
import 'package:movies_app/Modules/Movie%20Details/movie_details.dart';
import 'package:movies_app/Services/search_services.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();

  List<SearchModel> searchList = [];
  List<ResultModel> resultList = [];
  TypesModel? model;

  get index => null;

  Future<void> getSearchData({value}) async {
    List<SearchModel> res = await SearchServices().getSearchData(query: value);
    setState(() {
      searchList = res;
    });
  }
  
  void getTypes()async{
    TypesModel res = await SearchServices().getTypeData(type:'tvSeries', genre:'War',rows: 25);
    setState(() {
      model = res ;
      for(var i = 0 ; i < res.results!.length ; i++){
        if(res.results![i].primaryImage != null && res.results![i].averageRating != null){
          resultList.add(res.results![i]);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTypes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      getSearchData(value: value);
                    },
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.solidDarkColor.withOpacity(0.7),
                      hintText: 'Search',
                      labelStyle: const TextStyle(color: Colors.white),
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
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchController.text = '';
                          },
                          icon: const Icon(Icons.cancel_rounded)),
                    ),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        searchList = [] ;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('On Tv' , style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 18.0),)),
                TextButton(
                    onPressed: () {
                      navigateTo(context, const FiltersScreen(categories: 'All', genre: 'Action', country: 'All', year: '2021',));
                    },
                    child: Text(
                      'Filters',
                      style: TextStyle(color: MyColors.primaryColor),
                    ))
              ],
            ),
            ConditionalBuilder(
                condition: searchList.isNotEmpty,
                builder: (context) => Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => videoItem(searchList[index],index),
                      itemCount: searchList.length),
                ),
                fallback: (context) => ConditionalBuilder(
                    condition: resultList.isNotEmpty,
                    builder: (context) => Expanded(
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.5,
                        padding: const EdgeInsets.all(0),
                        children: List.generate(
                          resultList.length,(index) => gridBuilder(resultList[index] , index),
                        ),
                      ),
                    ),
                    fallback: (context) => SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                )
            )
          ],
        ),
      ),
    );
  }

  Widget videoItem(SearchModel model , index) => ConditionalBuilder(
        condition: model.primaryImage != null &&
            model.averageRating != null &&
            model.primaryTitle != null &&
            model.genres!.isNotEmpty &&
            model.description != null &&
            model.type != null,
        builder: (context) => GestureDetector(
          onTap: (){
            navigateTo(context, MovieDetailsScreen(index: index, id: model.id!, type: model.type!, genre: model.genres![0]));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
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
                          height: 10.0,
                        ),
                        Text(
                          model.type!.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  const EdgeInsetsDirectional.only(end: 5.0),
                                  child: Text(
                                    model.genres![0],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color:Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                if(model.genres!.length > 1)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(end: 5.0),
                                    child: Text(
                                      model.genres![1],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                if(model.genres!.length > 2)
                                  Padding(
                                    padding:  const EdgeInsetsDirectional.only(end: 5.0),
                                    child: Text(
                                      model.genres![2],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        )
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
}
