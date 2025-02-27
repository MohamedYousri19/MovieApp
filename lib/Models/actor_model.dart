class ActorDataModel{
  String? id ;
  ImageData? images ;
  Node? primaryImage ;
  NameData? actorName ;
  List<JobData> jobs = [] ;
  VideoData? videos ;

  ActorDataModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    images = ImageData.fromJson(json['images']);
    primaryImage = Node.fromJson(json['primaryImage']);
    actorName = NameData.fromJson(json['nameText']);
    videos = VideoData.fromJson(json['videos']);
    json['jobs'].forEach((element){
      jobs.add(JobData.fromJson(element));
    });
  }

  ActorDataModel({
    this.id,
    this.images,
    this.primaryImage,
    this.actorName,
    this.videos,
    required this.jobs,
});

}
// image
class ImageData{
  int? total ;
  List<Object> edges = [] ;

  ImageData.fromJson(Map<String,dynamic> json){
    total = json['total'];
    json['edges'].forEach((element){
      edges.add(Object.fromJson(element));
    });
  }

  ImageData({
    this.total
  });
}
class Object{
  Node? object ;
  String? typename ;

  Object.fromJson(Map<String,dynamic> json){
    object = Node.fromJson(json['node']);
    typename = json['__typename'];
  }

  Object({
    this.object,
    this.typename,
  });
}
class Node{
  String? id ;
  String? url ;
  int? height ;
  int? width ;

  Node.fromJson(Map<String,dynamic> json){
    id = json['id'];
    url = json['url'];
    height = json['height'];
    width = json['width'];
  }

  Node({
    this.id,
    this.url,
    this.height,
    this.width,
  });
}
//Name Text
class NameData{
  String? text ;
  String? typename ;

  NameData.fromJson(Map<String,dynamic> json){
    text = json['text'];
    typename = json['__typename'];
  }

  NameData({
    this.text,
    this.typename,
  });
}
// jop data
class JobData{
  CategoryData? categoryData ;

  JobData.fromJson(Map<String,dynamic> json){
    categoryData = CategoryData.fromJson(json['category']);
  }

  JobData({
    this.categoryData,
  });
}
// category
class CategoryData{
  String? text ;
  String? id ;

  CategoryData.fromJson(Map<String,dynamic> json){
    text = json['text'];
    id = json['id'];
  }

  CategoryData({
    this.text,
    this.id,
  });
}
// video data

class VideoData{
  int? total ;
  List<ObjectData> edges = [];

  VideoData.fromJson(Map<String,dynamic> json){
    total = json['total'];
    json['edges'].forEach((element){
      edges.add(ObjectData.fromJson(element));
    });
  }

  VideoData({
    required this.edges,
    this.total,
  });
}
//
class ObjectData{
  NodeData? nodeData ;
  String? typename ;

  ObjectData.fromJson(Map<String,dynamic> json){
    nodeData = NodeData.fromJson(json['node']);
    typename = json['__typename'];
  }

  ObjectData({
    this.nodeData,
    this.typename,
  });
}
// node video
class NodeData{
  ThumbnailData? thumbnailData ;
  String? id ;

  NodeData.fromJson(Map<String,dynamic> json){
    thumbnailData = ThumbnailData.fromJson(json['thumbnail']);
    id = json['id'];
  }

  NodeData({
    this.thumbnailData,
    this.id,
  });
}
// thumbnail
class ThumbnailData{
  String? url ;
  int? height ;
  int? width ;

  ThumbnailData.fromJson(Map<String,dynamic> json){
    url = json['url'];
    height = json['height'];
    width = json['width'];
  }

  ThumbnailData({
    this.url,
    this.height,
    this.width,
  });
}
