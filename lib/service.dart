import 'package:http/http.dart' as http;
import 'media.dart';

class ApiService{
  Future <List<Media>?> search(String searchString) async{
    //ADD FILTERING FOR EACH TYPE OF MEDIA
    try{
      List<Media> _medias = [];
      Uri omdbUrl = Uri.parse("https://www.omdbapi.com/?s=${searchString}&apikey=3ccd1614");
      Uri albumUrl = Uri.parse("https://ws.audioscrobbler.com/2.0/?method=album.search&album=${searchString}&api_key=e17bef65ef5c579e1a731114eea7aa2f&format=json&limit=20");
      Uri bookUrl = Uri.parse("https://www.googleapis.com/books/v1/volumes?q=intitle:${searchString}&maxResults=3&printType=books");
      var omdbResponse = await http.get(omdbUrl);
      var albumResponse = await http.get(albumUrl);
      var bookResponse = await http.get(bookUrl);
      if(omdbResponse.statusCode == 200 && !omdbResponse.body.contains("\"Response\":\"False\"")){
        _medias+=omdbFromJson(omdbResponse.body);
        print("a : ${_medias}");
      }
      if(albumResponse.statusCode == 200){
        _medias+=(albumsFromJson(albumResponse.body));
        print("b : ${_medias}");
      }
      if(bookResponse.statusCode == 200){
        _medias+=(booksFromJson(bookResponse.body));
        print("c : ${_medias}");
      }
      //print("c : ${_medias}");
      return _medias;
    }catch(e){
      print(e);
    }
  }
}