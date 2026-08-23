import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/home/presentation/pages/cust_home.dart';

class SignupCust extends StatefulWidget {
  final User user;
  final String email;
  final String password;
  const SignupCust({super.key, required this.user, required this.email, required this.password});

  @override
  State<SignupCust> createState() => _SignupCustState();
}

class _SignupCustState extends State<SignupCust> {
  late Customer customer = Customer.fromProfile(widget.user);
  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String imagepath = '';

  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();

  @override
  void dispose() {
    _phonecontroller.dispose();
    _addresscontroller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagepath = pickedFile.path;
        _image = File(imagepath);
      });
    }
  }


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
                        const Text("Where tradition meets modern living.", style: TextStyle(fontSize: 14, fontFamily: "Saira", color: Colors.grey),),
                        const SizedBox(height: 25,),
                        Container(
                          width: width*0.9,
                          height: 550,
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
                                      const Text("Profile Picture", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      const SizedBox(height: 10,),
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(46, 46, 45, 1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color.fromRGBO(252, 184, 25, 1),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: _image == null
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () => _pickImage(),
                                            icon: const Icon(Icons.add, color: Color.fromRGBO(252, 184, 25, 1)),      ),
                                        )
                                            : ClipOval(
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      const Text("Phone", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "phone", controller: _phonecontroller,),
                                      ),
                                      const SizedBox(height: 20,),
                                      const Text("Address", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "village or city", controller: _addresscontroller,),
                                      ),
                                      const SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () async{
                                          if (_key.currentState!.validate()){
                                            customer.phone=_phonecontroller.text;
                                            customer.address=_addresscontroller.text;
                                            AuthProvider c = AuthProvider(context: context);
                                            final cx = await c.signUp(
                                              email: widget.email,
                                              password: widget.password,
                                              profileData: customer,
                                              avatarFile: _image,
                                            );
                                            if(cx != null && mounted){
                                              customer = Customer.fromProfile(cx, address: _addresscontroller.text);
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(customer: customer)));
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(252, 184, 25, 1))
                                        ),
                                        child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
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
