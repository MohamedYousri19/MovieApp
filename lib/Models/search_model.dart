class SearchModel {
  String? id ;
  String? primaryTitle ;
  String? title ;
  String? primaryImage ;
  String? description ;
  int? startYear ;
  int? endYear ;
  int? runtimeMinutes ;
  String? contentRating ;
  late num? averageRating ;
  int? numVotes ;
  String? type ;
  List? genres;

  SearchModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    primaryTitle = json['primaryTitle'];
    title = json['title'];
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
  }

  SearchModel({
    this.id,
    this.primaryTitle,
    this.title,
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
  });

  Map<String,dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'startYear' : startYear,
      'endYear' : endYear,
      'description' : description,
      'contentRating' : contentRating,
      'numVotes' : numVotes,
      'type' : type,
      'averageRating' : averageRating,
      'primaryImage' : primaryImage,
      'runtimeMinutes' : runtimeMinutes,
      'primaryTitle' : primaryTitle,
      'genres' : genres,
    };
  }
}