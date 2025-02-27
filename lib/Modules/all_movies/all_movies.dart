import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/movie_model.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import '../../Shared/Styles/colors.dart';

class AllMovies extends StatefulWidget {
  final List<MovieDataModel> allMovies ;
  final int num ;
  const AllMovies({super.key,required this.allMovies, required this.num});

  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: widget.num == 0 ?
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('For You'),
          ],
        )
            :
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Popular'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => videoItem(widget.allMovies[index]),
                itemCount: widget.allMovies.length,
                separatorBuilder: (BuildContext context, int index) {
                  return line();
                },
            ),
          ),
        ],
      ),
    );
  }
  Widget videoItem(MovieDataModel model) => ConditionalBuilder(
    condition: model.primaryImage != null &&
        model.primaryTitle != null &&
        model.genres!.isNotEmpty &&
        model.description != null &&
        model.type != null,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(10.0),
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
    fallback: (context) => Container(),
  );
}
