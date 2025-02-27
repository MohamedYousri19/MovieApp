class TypesModel {
  int? rows ;
  int? numFound ;
  List<ResultModel>? results = [] ;

  TypesModel.fromJson(Map<String,dynamic> json){
    rows = json['rows'];
    numFound = json['numFound'];

    json['results'].forEach((element){
      results?.add(ResultModel.fromJson(element));
    });
  }

  TypesModel({
    this.rows,
    this.numFound,
    this.results,
  });

  Map<String,dynamic> toMap(){
    return{
      'rows' : rows,
      'numFound' : numFound,
      'uId' : results,
    };
  }
}

class ResultModel {
  String? id ;
  String? primaryTitle ;
  String? originalTitle ;
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
  bool? isAdult;
  String? releaseDate;

  ResultModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    primaryTitle = json['primaryTitle'];
    originalTitle = json['originalTitle'];
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
    isAdult = json['isAdult'];
    releaseDate = json['releaseDate'];
  }

  ResultModel({
    this.id,
    this.primaryTitle,
    this.originalTitle,
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
    this.isAdult,
    this.releaseDate,
  });

  Map<String,dynamic> toMap(){
    return{
      'id' : id,
      'originalTitle' : originalTitle,
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
      'isAdult' : isAdult,
      'releaseDate' : releaseDate,
    };
  }
}