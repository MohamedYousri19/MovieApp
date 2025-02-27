class MovieDataModel {
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
  String? type ;
  String? releaseDate ;
  String? language ;
  List? genres;
  List? countriesOfOrigin;
  List? spokenLanguages;

  MovieDataModel.fromJson(Map<String,dynamic> json){
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
    releaseDate = json['releaseDate'];
    countriesOfOrigin = json['countriesOfOrigin'];
    spokenLanguages = json['spokenLanguages'];
  }

  MovieDataModel({
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
    this.releaseDate,
    this.countriesOfOrigin,
    this.spokenLanguages,
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
      'releaseDate' : releaseDate,
      'language' : language,
      'countriesOfOrigin' : countriesOfOrigin,
      'spokenLanguages' : spokenLanguages,
    };
  }
}