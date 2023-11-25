import 'dart:convert';


List<Media> omdbFromJson(String str) {
  print('IN OMDB METHOD');
  return List<Media>.from(json.decode(str)['Search'].map((x) {
    return Media.fromJson(x);
  }));
}

List<Media> albumsFromJson(String str) {
  print("IN ALBUMS METHOD");
  print(json.decode(str)['results']['albummatches']['album']);
  return List<Media>.from(json.decode(str)['results']['albummatches']['album'].map((x) {
    return Media.albumFromJson(x);
  }));
}




class Media{
  String title = "";
  String year = "";
  String mediaType = "";
  String poster = "";
  bool checked = false;

  void check(){
    checked = !checked;
  }

  Media(this.title, this.year, this.mediaType, this.poster){

  }

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    json['Title'], json['Year'], json['Type'], json['Poster']
  );

  factory Media.albumFromJson(Map<String, dynamic> json) => Media(
    json['name'], json['artist'], "Album", json["image"][1]['#text']
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'year': year,
    'type': mediaType,
    'poster': poster
  };
}
