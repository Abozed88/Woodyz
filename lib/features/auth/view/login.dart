import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'signup.dart';
import 'package:woodyz/core/widgets/widgets.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? savedUser = await storage.read(key: "user_session");
    if (savedUser != null) {
      Map<String, dynamic> data = convert.jsonDecode(savedUser);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateBasedOnRole(data, context);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color.fromRGBO(46, 46, 45, 1),
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(
                'assets/images/log-sign-bckg.jpeg',
                fit: BoxFit.cover,)
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 25,),
                    const Text("WOODYZ", style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: "Western"),),
                    Text("Welcome to the store", style: TextStyle(fontSize: 14, color: Colors.grey[350], fontFamily: "Saira"),),
                    const SizedBox(height: 25,),
                    Container(
                      width: width * 0.9,
                      height: 350,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 46, 45, 1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color.fromRGBO(56, 56, 52, 1), width: 1.4)
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Form(
                              key: _key,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  const Text("Email Address", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                  SizedBox(
                                    width: width * 0.7,
                                    child: CustomTextField(hint: "you@gmail.com", controller: _emailcontroller,),
                                  ),
                                  const SizedBox(height: 20,),
                                  const Text("Password", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                  SizedBox(
                                    width: width * 0.7,
                                    child: CustomTextField(hint: "password", controller: _passcontroller, obscure: true,),
                                  ),
                                  const SizedBox(height: 20,),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_key.currentState!.validate()){
                                        User user = User(
                                            name: "user",
                                            email: _emailcontroller.text,
                                            password: _passcontroller.text,
                                            link: "",
                                            type: "",
                                            location: ""
                                        );
                                        await login(u: user, context: context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(252, 184, 25, 1))
                                    ),
                                    child: const Text("LOG IN", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 35),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account?", style: TextStyle(fontSize: 14, color: Colors.grey[350], fontFamily: "Saira")),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                                            },
                                            child: const Text("Sign Up", style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontStyle: FontStyle.italic, fontSize: 14, fontFamily: "Saira"))
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}