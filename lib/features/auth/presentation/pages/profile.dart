import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/profile_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class Profile extends StatefulWidget {
  final Customer? c;
  final Artisan? a;
  const Profile({super.key, this.c, this.a});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late dynamic u;
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
          top: 10,
          right: 10,
          child: IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: Colors.white,)),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    PImage(image_url: widget.c == null? widget.a!.avatarUrl : widget.c!.avatarUrl,),
                    const SizedBox(height: 10),
                    Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 25, color: Colors.white,),),
                    Text(u.type == "cust" ? "Customer" : "Artisan", style: const TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira"),),
                    const SizedBox(height: 20),
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
                          const SizedBox(
                            width: 80,
                            child: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1))),
                          ),
                          Expanded(
                            child: Text(u.phone ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
                          ),
                        ]
                    ),
                    const SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.address ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
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
                          const SizedBox(
                            width: 80,
                            child: Text("Shop", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.shop ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Colors.white,)),
                          ),
                        ]
                    ),
                    const SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text("Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Saira", color: Color.fromRGBO(252, 184, 25, 1),)),
                          ),
                          Expanded(
                            child: Text(u.skills == null ? "No skills" : u.skills!.join(', '), style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira", fontSize: 15, color: Colors.white,)),
                          ),
                        ]
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              const Preferences()
            ],
          ),
        )
      ],
    );
  }
}
