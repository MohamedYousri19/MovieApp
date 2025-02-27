import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Models/types_model.dart';
import '../../Services/search_services.dart';
import '../../Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';
import '../Movie Details/movie_details.dart';

class CatalogScreen extends StatefulWidget {
  final String type ;
  final String genre ;
  const CatalogScreen({super.key, required this.type, required this.genre});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<ResultModel> resultList = [];
  TypesModel? model;
  void getTypes()async{
    TypesModel res = await SearchServices().getTypeData(type:widget.type, genre:widget.genre,rows: 25);
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Catalog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
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
          ],
        ),
      ),
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
}
