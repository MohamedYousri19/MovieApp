import 'package:movies_app/Models/actor_model.dart';
import 'package:movies_app/Models/movie_details.dart';
import '../Helpers/api.dart';
import '../Models/types_model.dart';

class MovieDetailsService{

  Future<TypesModel> getTypeData({
    required type,
    required genre,
    required rows,
  })async{
    var data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/search?type=$type&genre=$genre&rows=$rows&sortOrder=ASC&sortField=id',headers:{
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    TypesModel model = TypesModel.fromJson(data);
    return model ;
  }


  Future<AllMovieDataModel> getAllMovieData(id)async{
    var data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/$id', headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    AllMovieDataModel allMovieDataModel = AllMovieDataModel.fromJson(data) ;

    return allMovieDataModel ;
  }

  Future<ActorDataModel> getActorData(id)async{
    var data = await Api().get(url: 'https://imdb146.p.rapidapi.com/v1/name/?id=$id', headers: {
      'x-rapidapi-host': 'imdb146.p.rapidapi.com',
      'x-rapidapi-key': 'e4a6957529msh7b506be5f231573p1e80c9jsn8c5bd845185c',
    });
    ActorDataModel allMovieDataModel = ActorDataModel.fromJson(data) ;

    return allMovieDataModel ;
  }
}