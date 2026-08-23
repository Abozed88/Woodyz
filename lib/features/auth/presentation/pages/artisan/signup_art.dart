import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/features/home/presentation/pages/art_home.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class SignupArt extends StatefulWidget {
  final User user;
  final String email;
  final String password;
  const SignupArt({super.key, required this.user, required this.email, required this.password});

  @override
  State<SignupArt> createState() => _SignupArtState();
}

class _SignupArtState extends State<SignupArt> {
  late Artisan artisan = Artisan.fromProfile(widget.user);
  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String imagepath = '';

  final TextEditingController _shopcontroller = TextEditingController();

  final List<String> _skills = [
    "Furniture", "Decor", "Bedroom", "Bowls", "Kitchenware", "Outdoor", "Art", "Toys", "Others",];
  final List<String> _selectedSkills = [];

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
                        const Text("Create Your Woodcraft Account", style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: "Saira"),),
                        const Text("Where you Spread Your Modern Art.", style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: "Saira"),),
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
                                      const Text("Shop Name", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      SizedBox(
                                        width: width*0.7,
                                        child: CustomTextField(hint: "shop", controller: _shopcontroller,),
                                      ),
                                      const SizedBox(height: 20,),
                                      const Text("Skills", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        width: width*0.7,
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: _skills.map((skill){
                                            final isSelected = _selectedSkills.contains(skill);
                                            return ChoiceChip(
                                                label: Text(skill, style: const TextStyle(color: Colors.white, fontFamily: "Saira"),),
                                                selected: isSelected,
                                                backgroundColor: const Color.fromRGBO(46, 46, 45, 1),
                                                selectedColor: Colors.black,
                                                disabledColor: const Color.fromRGBO(46, 46, 45, 1),
                                                checkmarkColor: const Color.fromRGBO(252, 184, 25, 1),
                                                side: const BorderSide(color: Color.fromRGBO(252, 184, 25, 1), width: 1.5),
                                                onSelected: (bool selected){
                                                  setState(() {
                                                    if(selected){
                                                      _selectedSkills.add(skill);
                                                    }else{
                                                      _selectedSkills.remove(skill);
                                                    }
                                                  });
                                                }
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () async{
                                          if (_key.currentState!.validate()){
                                            artisan.bio=_shopcontroller.text; // Mapping shop name to bio for now or adding bio field
                                            AuthProvider c = AuthProvider(context: context);
                                            final cx = await c.signUp(
                                              email: widget.email,
                                              password: widget.password,
                                              profileData: artisan,
                                              avatarFile: _image,
                                            );
                                            if(cx != null && mounted){
                                              artisan = Artisan.fromProfile(cx);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => Arthome(artisan: artisan)),
                                                    (route) => false,
                                              );
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(252, 184, 25, 1))
                                        ),
                                        child: const Text("SIGN UP", style: TextStyle(color: Colors.white),),
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
