class Model{
  String? id ;
  Model({
    this.id
});
  Model.fromJson(Map<String,dynamic> json){
    id = json['id'];
  }
}