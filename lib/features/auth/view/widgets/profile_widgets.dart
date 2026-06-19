import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../login.dart';

class PImage extends StatelessWidget {
  final String? image_url;
  const PImage({super.key, this.image_url});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromRGBO(46, 46, 45, 1),
            width: 1.5,
          )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(70),
        child: image_url == '' ? Image.asset('assets/images/no-profile.jpg', fit: BoxFit.cover,) :
        Image.network(
          '$image_url',
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color.fromRGBO(252, 184, 25, 1),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            print(exception);
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.broken_image,
                color: Colors.white54,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

const storage = FlutterSecureStorage();

class Preferences extends StatelessWidget {
   Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white, fontFamily: "Saira"),),
        SizedBox(height: 10,),
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 45, 1),
              border: Border.all(
                color: Color.fromRGBO(46, 46, 45, 1),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: Colors.white,),
          ),
          title: Text("Account & Security", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
        ),
        SizedBox(height: 10, ),
        Container(
          margin: EdgeInsetsGeometry.symmetric(horizontal: 20,),
          child: Divider(color: Colors.grey, thickness: 2,),
        ),
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 45, 1),
              border: Border.all(
                color: Color.fromRGBO(46, 46, 45, 1),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.question_mark_outlined, color: Colors.white,),
          ),
          title: Text("Help & Support", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
        ),
        SizedBox(height: 10, ),
        Container(
          margin: EdgeInsetsGeometry.symmetric(horizontal: 20,),
          child: Divider(color: Colors.grey, thickness: 2,),
        ),
        SizedBox(height: 10, ),
        Container(
          height: 55,
          margin: EdgeInsetsGeometry.symmetric(horizontal: 20,),
          child: ElevatedButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromRGBO(46, 46, 45, 1),
                      title: const Text(
                          "Log Out", style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1))),
                      content: const Text("Are you sure you want to log out?",
                          style: TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(
                              color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async{
                            await storage.delete(key: "user_session");
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()),
                            );
                          },
                          child: const Text("Log Out", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(46, 46, 45, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 18,fontWeight: FontWeight.bold,),
                  SizedBox(width: 10,),
                  Text("Log Out", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Saira")),
                ],
              )
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}
