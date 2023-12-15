import 'dart:convert';


List<Media> omdbFromJson(String str) {
  print('IN OMDB METHOD');
  if(json.decode(str)['Search']!=null){
    return List<Media>.from(json.decode(str)['Search'].map((x) {
      return Media.fromJson(x);
    }));
  }else{
    return [];
  }

}

List<Media> albumsFromJson(String str) {
  print("IN ALBUMS METHOD");
  print(json.decode(str)['results']['albummatches']['album']);
  return List<Media>.from(json.decode(str)['results']['albummatches']['album'].map((x) {
    print("TEST: ${x["image"][2]['#text']}");
    return Media.albumFromJson(x);
  })).where((element) => element.poster!=null&&element.poster.isNotEmpty).toList();
}

List<Media> booksFromJson(String str) {
  print("IN BOOKS METHOD");
  if(json.decode(str)['items']!=null){
    print(json.decode(str)['items']);
    return List<Media>.from(json.decode(str)['items'].map((x) {
      return Media.bookFromJson(x);
    }));
  }else{
    return [];
  }

}




class Media{
  String id = "";
  String title = "";
  String year = "";
  String mediaType = "";
  String poster = "";
  bool checked = false;

  void check(){
    checked = !checked;
  }

  Media(this.title, this.year, this.mediaType, this.poster,
      {this.id = '-1', this.checked = false}){

  }

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    json['Title']??"", json['Year']??"", json['Type']??"", json['Poster']??""
  );

  factory Media.albumFromJson(Map<String, dynamic> json) => Media(
    json['name']??"", json['artist']??"", "Album", json["image"][2]['#text']??""
  );

  factory Media.bookFromJson(Map<String, dynamic> json) => Media(
      json['volumeInfo']['title']??"", json['volumeInfo']['publishedDate']!=null ? json['volumeInfo']['publishedDate'].split("-")[0] : "", "Book", json['volumeInfo']['imageLinks']!=null ? json['volumeInfo']['imageLinks']['smallThumbnail'] : ""
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'year': year,
    'type': mediaType,
    'poster': poster
  };
}
