import 'package:flutter/foundation.dart';
import 'package:movies_app/Helpers/api.dart';
import 'package:movies_app/Models/movie_model.dart';

class MoviesServices{
  Future<List<MovieDataModel>> getData()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/top-box-office', headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<MovieDataModel> movies = [] ;
    for( var i = 0 ; i < 10 ; i++ ){
      movies.add(MovieDataModel.fromJson(data[i]));
    }
    if (kDebugMode) {
      print(movies[0].primaryTitle);
    }
    return movies ;
  }

  Future<List<MovieDataModel>> getForYouData()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/top250-movies', headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<MovieDataModel> forYouMovies = [];
    for( var i = 0 ; i < 15 ; i++ ){
      forYouMovies.add(MovieDataModel.fromJson(data[i]));
    }
    if (kDebugMode) {
      print(forYouMovies[0].primaryTitle);
    }
    return forYouMovies ;
  }

  Future<List<MovieDataModel>> getPopularData()async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/top250-tv', headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    List<MovieDataModel> popularMovies = [];
    for( var i = 0 ; i < 15 ; i++ ){
      popularMovies.add(MovieDataModel.fromJson(data[i]));
    }
    if (kDebugMode) {
      print(popularMovies[0].primaryTitle);
    }
    return popularMovies ;
  }
}