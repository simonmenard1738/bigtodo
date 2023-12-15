import 'package:flutter/material.dart';
import 'media.dart';

class RatingsScreen extends StatefulWidget {
  Media selected;
  RatingsScreen(this.selected, {super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState(selected);
}

class _RatingsScreenState extends State<RatingsScreen> {
  Media selected;
  _RatingsScreenState(this.selected);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Ratings"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white)
              ),
              constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 350
              ),
              child: Image.network(selected.poster),
            ),

            SizedBox(height: 35,),

            Text(selected.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                )),

            SizedBox(height: 35,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.orange, size: 40,),
                Icon(Icons.star, color: Colors.orange, size: 40,),
                Icon(Icons.star, color: Colors.orange, size: 40,),
                Icon(Icons.star, color: Colors.orange, size: 40,),
                Icon(Icons.star, color: Colors.orange, size: 40,),

              ],

            ),

            SizedBox(height: 15,),

            Text("Taken from PLACEHOLDER reviews", style: TextStyle(
                color: Colors.white
            ),),

            SizedBox(height: 25,),

            ElevatedButton(onPressed: (){

            }, child:Text("Add Review"))

          ],
        ),
      ),
    );
  }
}


