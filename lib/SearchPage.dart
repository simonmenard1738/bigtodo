import 'package:big_to_do/service.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'media.dart';

class Search extends StatefulWidget {
  Search({super.key});


  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ApiService service = ApiService();
  String currentFilter = "";
  List<Media> filteredList = [];

  void filter(String value){
    if(value!="-1" && searchedList.isNotEmpty){
      List<Media> temp = List<Media>.from(searchedList.where((element) => element.mediaType.toLowerCase()==value));
      if(temp.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No media found for this media type."), duration: Duration(seconds: 1),));
      }else{
        currentFilter = value;
        filteredList = temp;
      }
      print("value : ${searchedList}");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please search something before clicking one of these."), duration: Duration(seconds: 1),));
    }

  }

  List<Media> returnList() => filteredList.isEmpty ? searchedList : filteredList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        Container(
            child:
            ListTile(
              title: TextField(controller: searchController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), fillColor: Colors.white, hintText: "Find anything!", filled: true, hintStyle: TextStyle(color: Colors.grey)), style: TextStyle(color: Colors.black)),
              trailing: IconButton(onPressed: () async{
                String search = searchController.text;
                searchedList = [];
                filteredList = [];
                service.search(search).then((value) {

                  setState(() {
                    print("1 $searchedList");
                    if(value!=null){
                      for(Media media in value){
                        searchedList.add(media);
                      }
                    }
                    print("2 $searchedList");
                  });
                });

                searchController.clear();
              }, icon: Icon(Icons.search)),
            )


        ),

        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            padding: EdgeInsets.all(0),
            childAspectRatio: 8/1,
            shrinkWrap: true,

            children: [
              RadioListTile(value: filters[0], onChanged: (value){
                setState(() {
                  if(currentFilter!=value && value!=null){
                    print(value);
                    filter(value as String);
                  }else{
                    filteredList = [];
                    currentFilter = "";
                  }

                });
              }, groupValue: currentFilter, title: Text("Movies"), toggleable: true,),
              RadioListTile(
                value: filters[1], onChanged: (value){
                setState(() {
                  if(currentFilter!=value && value!=null){
                    print(value);
                    filter(value as String);
                  }else{
                    filteredList = [];
                    currentFilter = "";
                  }

                });
              }, groupValue: currentFilter, toggleable: true,
                title: Text("Games"),
              ),
              RadioListTile(
                value: filters[2], onChanged: (String? value){
                setState(() {
                  if(currentFilter!=value && value!=null){
                    print(value);
                    filter(value as String);
                  }else{
                    filteredList = [];
                    currentFilter = "";
                  }

                });
              }, groupValue: currentFilter, toggleable: true,
                title: Text("Books"),
              ),
              RadioListTile(
                value: filters[3],onChanged: (value){
                setState(() {
                  if(currentFilter!=value && value!=null){
                    print(value);
                    filter(value as String);
                  }else{
                    filteredList = [];
                    currentFilter = "";
                  }

                });
              }, groupValue: currentFilter, toggleable: true,
                title: Text("Music"),
              ),
            ],
          ),
        ),

        Expanded(child: Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(itemCount: returnList().length, shrinkWrap: true, itemBuilder: (context, index){
              return Card(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(title: Text(returnList()[index].title, style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(returnList()[index].year),
                    Text(returnList()[index].mediaType)
                  ],
                ), onTap: (){
                  showModalBottomSheet(context: context, builder: (BuildContext context){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 500,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: listButtons(returnList()[index], context),
                        ),
                      ),
                    );

                  });
                },
                ),
              );})

        ), flex: 1,)

      ],
    );
  }

  List<Widget> listButtons(Media selected, BuildContext context){
    print("In List: $searchedList");
    List<Widget> globalLists = [];
    globalLists.add(Text("${selected.title}: ${selected.mediaType}, ${selected.year}", style: TextStyle(fontWeight: FontWeight.bold)));
    print(selected.poster);
    if(selected.poster!="N/A"){
      if(selected.poster.isNotEmpty)
        globalLists.add(Image.network(selected.poster, width: 200));
    }
    for (var element in lists) {
      globalLists.add(
          ElevatedButton(onPressed: (){
            if(element.medias.where((element) => element.title==selected.title).isEmpty){
              setState(() {
                element.medias.add(selected);
              });
            }
            Navigator.pop(context);
          }, child: Text(element.name, style: TextStyle(color: Colors.black54),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),)
      );
    }
    return globalLists;
  }
}