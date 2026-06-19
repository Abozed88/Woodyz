import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/widgets/profile_widgets.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

class Profile extends StatefulWidget {
  final Customer? c;
  final Artisan? a;
  const Profile({super.key, this.c, this.a});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final u;
  @override
  void initState() {
    if(widget.c == null){
      u = widget.a as Artisan;
    }
    else{
      u = widget.c as Customer;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: IconButton(onPressed: (){}, icon: Icon(Icons.settings, color: Colors.white,)),
          top: 10,
          right: 10,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    PImage(image_url: widget.c == null? widget.a!.image : widget.c!.image,),
                    SizedBox(height: 10),
                    Text(u.name, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 25, color: Colors.white,),),
                    Text(u.type == "cust" ? "Customer" : "Artisan", style: TextStyle(color: const Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira"),),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              u is Customer ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1))),
                          ),
                          Expanded(
                            child: Text(u.phone ?? "N/A", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
                          ),
                        ]
                    ),
                    SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.address ?? "N/A", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
                          ),
                        ]
                    )
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text("Shop", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.shop ?? "N/A", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Colors.white,)),
                          ),
                        ]
                    ),
                    SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text("Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.skills == null ? "No skills" : u.skills!.join(', '), style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
                          ),
                        ]
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Preferences()
            ],
          ),
        )
      ],
    );
  }
}
