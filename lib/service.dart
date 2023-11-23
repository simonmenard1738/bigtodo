import 'package:http/http.dart' as http;
import 'media.dart';

class ApiService{
  Future <List<Media>?> search(String searchString) async{
    try{
      Uri url = Uri.parse("https://www.omdbapi.com/?s=${searchString}&apikey=3ccd1614");
      print(url.toString());
      var response = await http.get(url);
      if(response.statusCode == 200){
        List<Media> _medias = mediasFromJson(response.body);
        return _medias;
      }
    }catch(e){}
  }
}