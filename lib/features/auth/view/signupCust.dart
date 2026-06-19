import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/core/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

import '../../home/custhome.dart';

class Signup2 extends StatefulWidget {
  final User user;
  late Customer customer = Customer.fromUser(user);
  Signup2({super.key,required this.user});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {


  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
 // store selected image
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
    await _picker.pickImage(source: ImageSource.gallery); // or .camera

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
                        Text("Where tradition meets modern living.", style: TextStyle(fontSize: 14, fontFamily: "Saira", color: Colors.grey),),
                        SizedBox(height: 25,),
                        Container(
                          width: width*0.9,
                          height: 550,
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
                                      Text("Profile Picture", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(46, 46, 45, 1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color.fromRGBO(252, 184, 25, 1),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: _image == null
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () => _pickImage(),
                                            icon: Icon(Icons.add, color: Color.fromRGBO(252, 184, 25, 1)),      ),
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
                                      SizedBox(height: 20,),
                                      Text("Phone", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "phone", controller: _phonecontroller,),
                                      ),
                                      SizedBox(height: 20,),
                                      Text("Address", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "village or city", controller: _addresscontroller,),
                                      ),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () async{
                                          if (_key.currentState!.validate()){
                                            widget.customer.phone=_phonecontroller.text;
                                            widget.customer.address=_addresscontroller.text;
                                            widget.customer.image = imagepath;
                                            print("Customer validated and created: ${widget.customer.toString()}");
                                            AuthController c = AuthController(context: context);
                                            Customer? cx = await c.signupCust(c: widget.customer, image: _image) as Customer?;
                                            if(cx != null){
                                              widget.customer = cx;
                                              print("Customer added to DB: ${widget.customer.toString()}");
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(customer: widget.customer)));
                                            }
                                            else{
                                              print("Error in signup");
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Error in signup"),
                                                  backgroundColor: Colors.black54,
                                                  showCloseIcon: true,
                                                  closeIconColor: Color.fromRGBO(252, 184, 25, 1),
                                                  duration: Duration(seconds: 4),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Color.fromRGBO(252, 184, 25, 1))
                                        ),
                                        child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
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
