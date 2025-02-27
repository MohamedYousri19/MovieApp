import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:movies_app/Models/actor_model.dart';
import 'package:movies_app/Shared/Styles/colors.dart';
import '../../Services/movie_details_service.dart';

class ActorsScreen extends StatefulWidget {
  final String id ;
  final String description ;
  const ActorsScreen({super.key, required this.id, required this.description});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ActorDataModel? actorDataModel ;

  Future<void> getData() async {
    ActorDataModel res = await MovieDetailsService().getActorData(widget.id) ;
    setState(() {
      actorDataModel = res ;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _tabController = TabController(length: 2, vsync: this);
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
          condition: actorDataModel != null ,
          builder: (context) => Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      height: 400.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor
                      ),
                      child: CachedNetworkImage(imageUrl: '${actorDataModel!.primaryImage!.url}',fit: BoxFit.cover,)
                  ),
                  Container(
                    height: 400.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          MyColors.darkColor,
                          MyColors.darkColor.withOpacity(0.8),
                        ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 55.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: const Icon(CupertinoIcons.back , size: 25.0,)),
                              Padding(
                                padding:  const EdgeInsetsDirectional.only(start: 55.0),
                                child: Text('${actorDataModel!.actorName!.text}',style: const TextStyle(fontSize: 25.0 , fontWeight: FontWeight.w600),),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          CircleAvatar(
                            radius: 85.0,
                            backgroundImage: CachedNetworkImageProvider('${actorDataModel!.primaryImage!.url}'),
                          ),
                          const SizedBox(height: 10.0,),
                          const Text('35 Movies',style: TextStyle(fontSize: 17.0),),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              const Text('top 20' , style: TextStyle(fontSize: 14.0),),
                              if(actorDataModel!.jobs[0].categoryData!.text != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text('${actorDataModel!.jobs[0].categoryData!.text}' , style: const TextStyle( fontSize: 14.0),),
                                ),
                              if(actorDataModel!.jobs[1].categoryData!.text != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text('${actorDataModel!.jobs[1].categoryData!.text}' , style: const TextStyle( fontSize: 14.0),),
                                ),
                              if(actorDataModel!.jobs[3].categoryData!.text != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text('${actorDataModel!.jobs[3].categoryData!.text}' , style: const TextStyle( fontSize: 14.0),),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child:Icon(AntDesign.instagram , color: MyColors.primaryColor,size: 20.0,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child:Icon(AntDesign.facebook_square , color: MyColors.primaryColor,size: 20.0,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child:Icon(AntDesign.twitter , color: MyColors.primaryColor,size: 20.0,),
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
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
                          Tab(text: "Filmography"),
                          Tab(text: "Biography"),
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
                                actorDataModel!.videos!.edges.length,(index) => gridBuilder(actorDataModel!.videos!.edges[index] ,index),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  widget.description,
                                  maxLines: 3,
                                  style:  const TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:[
                                    const Text(
                                      'Gallery',
                                      style:  TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: (){},
                                              child: const Text(
                                                'See All',
                                                style:  TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context ,index) => galleryBuilder(actorDataModel!.images!.edges[index]),
                                    itemCount: actorDataModel!.images!.edges.length,
                                  
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator(),)
      )
    );
  }
  Widget gridBuilder( ObjectData model ,index ) => GestureDetector(
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
            imageUrl: '${model.nodeData!.thumbnailData!.url}',
            fit: BoxFit.cover,
            height: 300.0,
            width: 200.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
              ],
            ),
          )
        ],
      ),
    ),
  );

  Widget galleryBuilder(Object model) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      height: 400.0,
      width: 150.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: MyColors.solidDarkColor
      ),
      child: CachedNetworkImage(
        imageUrl: '${model.object!.url}',
        fit: BoxFit.cover,
      ),
    ),
  );
}
