import 'dart:convert';


List<Media> mediasFromJson(String str) {
  print(json.decode(str)['Search']);
  return List<Media>.from(json.decode(str)['Search'].map((x) {
    return Media.fromJson(x);
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

  Map<String, dynamic> toJson() => {
    'title': title,
    'year': year,
    'type': mediaType,
    'poster': poster
  };
}
