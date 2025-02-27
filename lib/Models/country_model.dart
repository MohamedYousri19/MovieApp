class CountryModel{
  String? name ;
  CountryModel.fromJson(Map<String,dynamic>json){
    name = json['name'];
  }
}