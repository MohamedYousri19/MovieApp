import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Modules/Catalog%20Screen/catalog_screen.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import 'package:movies_app/Shared/Styles/colors.dart';

import '../../Models/country_model.dart';
import '../../Services/filter_service.dart';

class FiltersScreen extends StatefulWidget {
  final String categories ;
  final String genre ;
  final String country ;
  final String year ;
  const FiltersScreen({super.key,  required this.categories, required this.genre, required this.country, required this.year});
  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
   String? categories ;
   String? genre ;
   String? country ;
  List<dynamic> types = [] ;
  List<dynamic> genres = [] ;
  List<CountryModel> countries = [] ;
  Future<void> getTypes() async {
    List<dynamic> res = await FilterService().getData();
    setState(() {
      types = res ;
    });

    List<dynamic> res1 = await FilterService().getGenres();
    setState(() {
      genres = res1 ;
    });

    List<CountryModel> res2 = await FilterService().getCountries();
    setState(() {
      countries = res2 ;
    });
  }
  int? isClicked ;
  int? isClickedTypes ;
  int? isClickedGenres ;
  int? isClickedCountries ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTypes();
    setState(() {
      categories = widget.categories;
      genre = widget.genre;
      country = widget.country;
    });
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Filters'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isClickedGenres = null;
                  isClicked = null;
                  isClickedCountries = null;
                  isClickedTypes = null;
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              )
          )
        ],
      ),
      body:  ConditionalBuilder(
          condition: categories!.isNotEmpty && genre!.isNotEmpty && country!.isNotEmpty ,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sorting',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    items('Popular' , 0),
                    items('New' , 1),
                    items('Rating IMDB' , 2),
                  ],
                ),
                const SizedBox(height: 30.0,),
                const Text(
                  'Filters',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0,),
                filters('Categories',categories),
                const SizedBox(height: 10.0,),
                SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) => elements(types[index], index),
                      itemCount: types.length
                  ),
                ),
                filters('Genre',genre),
                const SizedBox(height: 10.0,),
                SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) => genresElements(genres[index], index),
                      itemCount: genres.length
                  ),
                ),
                filters('Country',country),
                const SizedBox(height: 10.0,),
                SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) => countryElements(countries[index], index),
                      itemCount: countries.length
                  ),
                ),
                const Spacer(),
                defaultButton(function: (){
                  navigateTo(context, CatalogScreen(type: categories!, genre: genre!));
                }, name: 'Accept Filters')
              ],
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
      )
    );
  }
  Widget items(name , index) => GestureDetector(
    onTap: (){
      setState(() {
        isClicked = index ;
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isClicked == index ? Colors.blueGrey[700] : MyColors.solidDarkColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20.0),
          border: isClicked == index ? Border(
            top: BorderSide(
              color: MyColors.primaryColor,
              width: 1.0
            ),
            bottom: BorderSide(
              color: MyColors.primaryColor,
              width: 1.0
            ),
            right: BorderSide(
              color: MyColors.primaryColor,
              width: 1.0
            ),
            left: BorderSide(
              color: MyColors.primaryColor,
              width: 1.0
            ),
          ) : null
        ),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    ),
  );
  
  Widget filters(variable , value) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              variable,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    ],
  );
  
  Widget elements(name , index) => GestureDetector(
    onTap: (){
      setState(() {
        isClickedTypes = index ;
        categories = name ;
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: isClickedTypes == index ? Colors.blueGrey[700] : MyColors.solidDarkColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0),
            border: isClickedTypes == index ? Border(
              top: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              bottom: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              right: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              left: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
            ) : null
        ),
        child: Text(
          textAlign: TextAlign.center,
          name,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    ),
  );

  Widget genresElements(name , index) => GestureDetector(
    onTap: (){
      setState(() {
        isClickedGenres = index ;
        genre = name ;
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: isClickedGenres == index ? Colors.blueGrey[700] : MyColors.solidDarkColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0),
            border: isClickedGenres == index ? Border(
              top: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              bottom: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              right: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              left: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
            ) : null
        ),
        child: Text(
          textAlign: TextAlign.center,
          name,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    ),
  );

  Widget countryElements(CountryModel model , index) => GestureDetector(
    onTap: (){
      setState(() {
        country = model.name ;
        isClickedCountries = index ;

      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: isClickedCountries == index ? Colors.blueGrey[700] : MyColors.solidDarkColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0),
            border: isClickedCountries == index ? Border(
              top: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              bottom: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              right: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
              left: BorderSide(
                  color: MyColors.primaryColor,
                  width: 1.0
              ),
            ) : null
        ),
        child: Text(
          textAlign: TextAlign.center,
          model.name!,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    ),
  );
}
