import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/widgets/upload_widgets.dart';
import 'package:woodyz/features/controller/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/widgets/widgets.dart';
import '../../../controller/products_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Upload extends StatefulWidget {
  final Artisan artisan;
  Upload({super.key, required this.artisan});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _desccontroller = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String imagepath = '';

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

  void Reset(){
    setState(() {
      _namecontroller.clear();
      _desccontroller.clear();
      imagepath = '';
      _image = null;
    });
  }

  Product p = Product.init();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromRGBO(30, 30, 30, 1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text("Add your creation",
                  style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
              const Text("Your product, your spotlight",
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: "Saira")),
              const SizedBox(height: 25),

              const Text("Product Image", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira")),
              const SizedBox(height: 10),

              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(46, 46, 45, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(252, 184, 25, 1),
                    width: 1.5,
                  ),
                ),
                child: _image == null
                    ? Center(
                  child: IconButton(
                    onPressed: () => _pickImage(),
                    icon: const Icon(Icons.add,
                        color: Color.fromRGBO(252, 184, 25, 1)),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Product Name", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira")),
              SizedBox(
                width: width * 0.8,
                child: CustomTextField(hint: "product name", controller: _namecontroller),
              ),

              const SizedBox(height: 20),
              const Text("Description", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira")),
              SizedBox(
                width: width * 0.8,
                child: CustomTextField(hint: "describe..", controller: _desccontroller),
              ),

              const SizedBox(height: 20),
              ChooseCategory(p: p),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Price (in \$):", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira")),
                  const SizedBox(width: 15),
                  NumberIndicator(p: p),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async{
                  if (_key.currentState!.validate()) {
                    try {
                      p.name = _namecontroller.text;
                      p.description = _desccontroller.text;
                      p.img = imagepath;
                      p.artid = widget.artisan.id;
                      Products_controller PC = Products_controller();
                      p = await PC.addProduct(p, _image);
                      if(p.pid != null){
                        Fluttertoast.showToast(
                            msg: "Upload Successful!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color.fromRGBO(252, 184, 25, 1),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Reset();
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Upload Failed!!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                        );
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Upload Failed: ${e.toString()}",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(252, 184, 25, 1),
                  minimumSize: Size(width * 0.6, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("UPLOAD", style: TextStyle(color: Colors.white, fontFamily: "Saira")),
              ),
              const SizedBox(height: 40), // Crucial for scrolling past the bottom of the tab
            ],
          ),
        ),
      ),
    );
  }
}
