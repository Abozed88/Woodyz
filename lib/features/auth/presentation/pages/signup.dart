import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/signup_cust.dart';
import 'package:woodyz/features/auth/presentation/pages/artisan/signup_art.dart';
import 'package:woodyz/features/auth/presentation/widgets/signup_widgets.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class Signup extends StatefulWidget {
   const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _key = GlobalKey();

  String _chosenType = "cust";

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _linkcontroller = TextEditingController();

  late User _user = User(
      username: _linkcontroller.text,
      fullName: _namecontroller.text,
      role: 'customer',
      location: "Beirut"
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset(
                  'assets/images/log-sign-bckg.jpeg',
                  fit: BoxFit.cover,)
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Color.fromRGBO(252, 184, 25, 1)),
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 25,),
                      const Text("Create Your Woodcraft Account", style: TextStyle(fontSize: 25, fontFamily: "Saira", color: Colors.white),),
                      Text("join our local community of master artisans", style: TextStyle(fontSize: 14, fontFamily: "Saira", color: Colors.grey[350]),),
                      const SizedBox(height: 25,),
                      Container(
                        width: width*0.9,
                        height: 600,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(46, 46, 45, 1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color.fromRGBO(56, 56, 52, 1),width: 1.4,)
                        ),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Form(
                                key: _key,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20,),
                                    const Text("Name", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "name", controller: _namecontroller,),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text("Email Address", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "you@gmail.com", controller: _emailcontroller,),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text("Password", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "password", controller: _passcontroller, obscure: true,),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text("Instagram Username", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "paste your name", controller: _linkcontroller),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text("Select Account Type",style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TypeRadio(
                                          type: "cust",
                                          selectedType: _chosenType,
                                          onChanged: (value) {
                                            setState(() {
                                              _chosenType = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: width*0.075,),
                                        TypeRadio(
                                          type: "art",
                                          selectedType: _chosenType,
                                          onChanged: (value) {
                                            setState(() {
                                              _chosenType = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Location(user: _user,),
                                    const SizedBox(height: 20,),
                                    ElevatedButton(
                                      onPressed: (){
                                        if (_key.currentState!.validate()){
                                          _user = User(
                                              username: _linkcontroller.text,
                                              fullName: _namecontroller.text,
                                              role: _chosenType == 'cust' ? 'customer' : 'artisan',
                                              location: _user.location
                                          );
                                          if(_chosenType == "cust"){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupCust(user: _user, email: _emailcontroller.text, password: _passcontroller.text)));
                                          }
                                          else if(_chosenType == "art"){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupArt(user: _user, email: _emailcontroller.text, password: _passcontroller.text)));
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(252, 184, 25, 1))
                                      ),
                                      child: const Text("Next", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                    )
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50,),
                    ],
                  ),
                )
              ],
            ),
          )
      )
    );
  }
}
