import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/signupCust.dart';
import 'artisian/signupArt.dart';
import 'widgets/signup_widgets.dart';
import 'package:woodyz/core/widgets/widgets.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

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
      name: _namecontroller.text,
      email: _emailcontroller.text,
      password: _passcontroller.text,
      link: _linkcontroller.text,
      type: _chosenType,
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
                    icon: Icon(Icons.arrow_back_rounded, color: Color.fromRGBO(252, 184, 25, 1)),
                    onPressed: () {
                      Navigator.pop(context); // Navigates back to the previous screen
                    },
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Text("Create Your Woodcraft Account", style: TextStyle(fontSize: 25, fontFamily: "Saira", color: Colors.white),),
                      Text("join our local community of master artisans", style: TextStyle(fontSize: 14, fontFamily: "Saira", color: Colors.grey[350]),),
                      SizedBox(height: 25,),
                      Container(
                        width: width*0.9,
                        height: 600,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(46, 46, 45, 1),
                            borderRadius: BorderRadius.circular(12),
                            border: BoxBorder.fromBorderSide(BorderSide(color: Color.fromRGBO(56, 56, 52, 1),width: 1.4,))
                        ),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Form(
                                key: _key,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20,),
                                    Text("Name", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "name", controller: _namecontroller,),
                                    ),
                                    SizedBox(height: 20,),
                                    Text("Email Address", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "you@gmail.com", controller: _emailcontroller,),
                                    ),
                                    SizedBox(height: 20,),
                                    Text("Password", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "password", controller: _passcontroller, obscure: true,),
                                    ),
                                    SizedBox(height: 20,),
                                    Text("Instagram Username", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(
                                      width: width*0.7,
                                      child: CustomTextField(hint: "paste your name", controller: _linkcontroller),
                                    ),
                                    SizedBox(height: 20,),
                                    Text("Select Account Type",style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                    SizedBox(height: 10,),
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
                                    SizedBox(height: 10,),
                                    Location(user: _user,),
                                    SizedBox(height: 20,),
                                    ElevatedButton(
                                      onPressed: (){
                                        if (_key.currentState!.validate()){
                                          _user = User(
                                              name: _namecontroller.text,
                                              email: _emailcontroller.text,
                                              password: _passcontroller.text,
                                              link: _linkcontroller.text,
                                              type: _chosenType,
                                              location: _user.location
                                          );
                                          if(_chosenType == "cust"){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup2(user: _user)));
                                          }
                                          else if(_chosenType == "art"){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupArt(user: _user)));
                                          }
                                          // print("User validated and created: ${_user.name} ${_user.location}");
                                          // AuthController c = AuthController(context: context);
                                          // c.signup(u: _user, image: null);

                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(Color.fromRGBO(252, 184, 25, 1))
                                      ),
                                      child: Text("Next", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                    )
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
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
