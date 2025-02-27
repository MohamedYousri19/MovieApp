class AllMovieDataModel {
  String? id ;
  String? url ;
  String? primaryTitle ;
  String? primaryImage ;
  String? description ;
  int? startYear ;
  int? endYear ;
  int? runtimeMinutes ;
  String? contentRating ;
  late num averageRating ;
  int? numVotes ;
  int? grossWorldwide ;
  int? budget ;
  String? type ;
  String? language ;
  List? genres;
  List? countriesOfOrigin;
  List? spokenLanguages;
  List<CastDataModel> cast = [] ;

  AllMovieDataModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    url = json['url'];
    primaryTitle = json['primaryTitle'];
    primaryImage = json['primaryImage'];
    description = json['description'];
    startYear = json['startYear'];
    endYear = json['endYear'];
    runtimeMinutes = json['runtimeMinutes'];
    contentRating = json['contentRating'];
    averageRating = json['averageRating'];
    numVotes = json['numVotes'];
    type = json['type'];
    genres = json['genres'];
    language = json['language'];
    countriesOfOrigin = json['countriesOfOrigin'];
    spokenLanguages = json['spokenLanguages'];
    budget = json['budget'];
    grossWorldwide = json['grossWorldwide'];

    json['cast'].forEach((element){
      cast.add(CastDataModel.fromJson(element));
    });
  }

  AllMovieDataModel({
    this.id,
    this.url,
    this.primaryTitle,
    this.primaryImage,
    this.description,
    this.startYear,
    this.endYear,
    this.runtimeMinutes,
    this.contentRating,
    required this.averageRating,
    this.numVotes,
    this.type,
    this.genres,
    this.language,
    this.countriesOfOrigin,
    this.spokenLanguages,
    this.budget,
    this.grossWorldwide,
    required this.cast,
  });

  Map<String,dynamic> toMap(){
    return{
      'id' : id,
      'title' : primaryTitle,
      'startYear' : startYear,
      'endYear' : endYear,
      'description' : description,
      'contentRating' : contentRating,
      'numVotes' : numVotes,
      'type' : type,
      'averageRating' : averageRating,
      'primaryImage' : primaryImage,
      'runtimeMinutes' : runtimeMinutes,
      'url' : url,
      'genres' : genres,
      'language' : language,
      'countriesOfOrigin' : countriesOfOrigin,
      'spokenLanguages' : spokenLanguages,
      'budget' : budget,
      'grossWorldwide' : grossWorldwide,
      'cast' : cast,
    };
  }
}

class CastDataModel{
  String? id ;
  String? url ;
  String? fullName ;
  String? job ;
  List? characters ;

  CastDataModel({
    this.id,
    this.url,
    this.fullName,
    this.job,
    this.characters,
});
  CastDataModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    url = json['url'];
    fullName = json['fullName'];
    job = json['job'];
    characters = json['characters'];
  }
}