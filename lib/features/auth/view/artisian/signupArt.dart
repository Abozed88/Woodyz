import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/features/home/artHome.dart';
import 'package:woodyz/core/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/auth/view/widgets/signup_widgets.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

class SignupArt extends StatefulWidget {
  final User user;
  late Artisan artisan = Artisan.fromUser(user);
  SignupArt({super.key,required this.user});

  @override
  State<SignupArt> createState() => _SignupArtState();
}

class _SignupArtState extends State<SignupArt> {

  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String imagepath = '';

  final TextEditingController _shopcontroller = TextEditingController();

  final List<String> _skills = [
    "Furniture", "Decor", "Bedroom", "Bowls", "Kitchenware", "Outdoor", "Art", "Toys", "Others",];
  List<String> _selectedSkills = [];

  @override
  void dispose() {
    _shopcontroller.dispose();
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
                        Text("Create Your Woodcraft Account", style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: "Saira"),),
                        Text("Where you Spread Your Modern Art.", style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: "Saira"),),
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
                                      Text("Shop Name", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "shop", controller: _shopcontroller,),
                                      ),
                                      SizedBox(height: 20,),
                                      Text("Skills", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(height: 10,),
                                      SizedBox(
                                        width: width*0.7,
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: _skills.map((skill){
                                            final isSelected = _selectedSkills.contains(skill);
                                            return ChoiceChip(
                                                label: Text(skill, style: TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                                selected: isSelected,
                                                backgroundColor: Color.fromRGBO(46, 46, 45, 1),
                                                selectedColor: Colors.black,
                                                disabledColor: Color.fromRGBO(46, 46, 45, 1),
                                                checkmarkColor: Color.fromRGBO(252, 184, 25, 1),
                                                side: BorderSide(color: Color.fromRGBO(252, 184, 25, 1), width: 1.5),
                                                onSelected: (bool selected){
                                                  setState(() {
                                                    if(selected){
                                                      _selectedSkills.add(skill);
                                                      print(_selectedSkills);
                                                    }else{
                                                      _selectedSkills.remove(skill);
                                                      print(_selectedSkills);
                                                    }
                                                  });
                                                }
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () async{
                                          if (_key.currentState!.validate()){
                                            widget.artisan.shop=_shopcontroller.text;
                                            widget.artisan.skills=_selectedSkills;
                                            widget.artisan.image = imagepath;
                                            print("Artisan validated and created: ${widget.artisan.toString()}");
                                            AuthController c = AuthController(context: context);
                                            Artisan? cx = await c.signupArt(a: widget.artisan, image: _image);
                                            if(cx != null){
                                              widget.artisan = cx;
                                              print("Artisan added to DB: ${widget.artisan.toString()}");
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => Arthome(artisan: widget.artisan)),
                                                    (route) => false,
                                              );
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
                                        child: Text("SIGN UP", style: TextStyle(color: Colors.white),),
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
