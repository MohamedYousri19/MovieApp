import 'package:flutter/foundation.dart';
import 'package:movies_app/Models/country_model.dart';

import '../Helpers/api.dart';

class FilterService{
  Future<List<dynamic>> getData()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/types',headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<dynamic> types = [] ;
    for( var i = 0 ; i < data.length; i++ ){
      types.add(data[i]);
    }
    if (kDebugMode) {
      print(types[0]);
    }
    return types ;
  }
  Future<List<dynamic>> getGenres()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/genres',headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<dynamic> genres = [] ;
    for( var i = 0 ; i < data.length; i++ ){
      genres.add(data[i]);
    }
    if (kDebugMode) {
      print(genres[0]);
    }
    return genres ;
  }
  Future<List<CountryModel>> getCountries()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/countries',headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<CountryModel> countries = [] ;
    for( var i = 0 ; i < data.length; i++ ){
      countries.add(CountryModel.fromJson(data[i]));
    }
    if (kDebugMode) {
      print(countries[0]);
    }
    return countries ;
  }
}