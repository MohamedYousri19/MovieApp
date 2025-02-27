import 'package:flutter/foundation.dart';
import 'package:movies_app/Models/search_model.dart';
import 'package:movies_app/Models/types_model.dart';
import '../Helpers/api.dart';

class SearchServices{

  Future<List<SearchModel>> getSearchData({query})async{
    List<dynamic> data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/autocomplete?query=$query',headers: {
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': '52f10f4421msh24699a090587912p1ecb2bjsn642456c9abcc',
    });

    List<SearchModel> searchData = [] ;
    for( var i = 0 ; i < data.length ; i++ ){
      searchData.add(SearchModel.fromJson(data[i]));
    }
    if (kDebugMode) {
      print(searchData);
    }
    return searchData ;
  }

  Future<TypesModel> getTypeData({
    required type,
    required genre,
    required rows,
})async{
    var data = await Api().get(url: 'https://imdb236.p.rapidapi.com/imdb/search?type=$type&genre=$genre&rows=$rows&sortOrder=ASC&sortField=id',headers:{
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
      'x-rapidapi-key': '52f10f4421msh24699a090587912p1ecb2bjsn642456c9abcc',
    });
    TypesModel model = TypesModel.fromJson(data);
    return model ;
  }
}