class UserDataModel {
 String? email ;
 String? image ;
 String? uId ;
 String? username ;

 UserDataModel.fromJson(Map<String,dynamic> json){
  email = json['email'];
  image = json['image'];
  uId = json['uId'];
  username = json['username'];
 }

 UserDataModel({
  this.email,
  this.image,
  this.uId,
  this.username,
 });

 Map<String,dynamic> toMap(){
  return{
   'email' : email,
   'image' : image,
   'uId' : uId,
   'username' : username,
  };
 }
}