// import 'package:flutter/material.dart';
// import 'package:woodyz/features/auth/view/auth.dart';
// import 'test2.dart';
// import 'package:provider/provider.dart';
//
// class ConfirmProvider with ChangeNotifier {
//   String _password = '';
//   String _confirmPassword = '';
//
//   String get password => _password;
//   String get confirmPassword => _confirmPassword;
//
//   void setPassword(String value) {
//     _password = value;
//     notifyListeners();
//   }
//
//   void setConfirmPassword(String value) {
//     _confirmPassword = value;
//     notifyListeners();
//   }
//
//   bool get isPasswordConfirmed {
//     return _password.isNotEmpty &&
//         _confirmPassword.isNotEmpty &&
//         _password == _confirmPassword;
//   }
// }
//
// class Feilds extends StatefulWidget {
//   final TextEditingController controller;
//   final String type;
//   bool obscure = false;
//   Feilds({super.key, required TextEditingController this.controller,required String this.type, this.obscure=false});
//
//   @override
//   State<Feilds> createState() => _FeildsState();
// }
//
// class _FeildsState extends State<Feilds> {
//   @override
//   Widget build(BuildContext context) {
//     final confirmProvider = Provider.of<ConfirmProvider>(context);
//
//     return TextFormField(
//       controller: widget.controller,
//       obscureText: widget.obscure,
//       keyboardType: widget.type == "Phone" ? TextInputType.phone : TextInputType.text,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontFamily: 'Manrope',
//         fontWeight: FontWeight.w500,
//       ),
//       textAlign: TextAlign.center,
//       decoration: InputDecoration(
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.white, width: 1.0),
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.white, width: 1.0),
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         labelText: widget.type,
//         prefixIcon: widget.type == "Email" ? Icon(Icons.email, color: Color.fromRGBO(101, 31, 255, 1.0),):
//         (widget.type == "Phone"? Icon(Icons.phone, color: Color.fromRGBO(101, 31, 255, 1.0),) : Icon(Icons.password, color: Color.fromRGBO(101, 31, 255, 1.0),)) ,
//         suffixIcon: (widget.type == "Password" || widget.type == "Retype Password") ?IconButton(
//           icon: Icon(
//             widget.obscure ? Icons.visibility_off : Icons.visibility,
//             color: Color.fromRGBO(101, 31, 255, 1.0),
//           ),
//           onPressed: () {
//             setState(() {
//               widget.obscure = !widget.obscure; // toggle state
//             });
//           },
//         ):null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//       ),
//       onChanged: (value){
//         if(widget.type == "Password"){
//           confirmProvider.setPassword(value);
//         }
//         if(widget.type == "Retype Password"){
//           confirmProvider.setConfirmPassword(value);
//         }
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "*required*";
//         }
//         if (widget.type == "Email" && (!value.contains("@") || !value.contains(".com"))) {
//           return "should look like '*******@***.com'";
//         }
//         if(widget.type == 'Password' && value.length> 20) {
//           return "too long password!";
//         }
//         if(widget.type == "Retype Password" ) {
//           if(!confirmProvider.isPasswordConfirmed) {
//             return "password mismatch";
//           }
//         }
//         return null;
//       },
//     );
//   }
// }
//
// class Registeration extends StatelessWidget {
//   Registeration({super.key});
//
//   final _formkey = GlobalKey<FormState>();
//   TextEditingController _phonecontroller = TextEditingController();
//   TextEditingController _emailcontroller = TextEditingController();
//   TextEditingController _passwordcontroller = TextEditingController();
//   TextEditingController _repasswordcontroller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/omi-head.webp"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   Card(
//                     color: Colors.white.withValues(alpha: 0.4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                     margin: const EdgeInsets.symmetric(vertical: 24),
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Form(
//                         key: _formkey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               "Sign Up",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromRGBO(101, 31, 255, 1.0),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Feilds(controller: _emailcontroller, type: "Email"),
//                             const SizedBox(height: 16),
//                             Feilds(controller: _phonecontroller, type: "Phone"),
//                             const SizedBox(height: 16),
//                             Feilds(controller: _passwordcontroller, type: "Password", obscure: true,),
//                             const SizedBox(height: 16),
//                             Feilds(controller: _repasswordcontroller, type: "Retype Password", obscure: true,),
//                             const SizedBox(height: 24),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: () async{
//                                   if(_formkey.currentState!.validate()) {
//                                     print("validated");
//                                     User u = User(email: _emailcontroller.text, phone: _phonecontroller.text, password: _passwordcontroller.text);
//
//                                     String status = await Authentication().signup(u);
//                                     if(status == "success"){
//                                       print("success!!!!!!!!!!!!!");
//                                     }
//                                     else{
//                                       print(status);
//                                     }
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(vertical: 16),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(13),
//                                   ),
//                                   backgroundColor: Color.fromRGBO(101, 31, 255, 1.0),
//                                 ),
//                                 child: Text(
//                                   "SIGN UP",
//                                   style: const TextStyle(fontSize: 18.0, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login2()));
//                               },
//                               child: Text(
//                                 "already have account? Log in",
//                                 style: TextStyle(color: Color.fromRGBO(101, 31, 255, 1.0),),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Expanded(
//                           child: Divider(
//                             color: Colors.black,
//                             thickness: 1,
//                             indent: 10,
//                             endIndent: 10,
//                           )
//                       ),
//                       Text("OR", style: TextStyle(color: Color.fromRGBO(101, 31, 255, 1.0), fontSize: 14),),
//                       const Expanded(
//                           child: Divider(
//                             color: Colors.black,
//                             thickness: 1,
//                             indent: 10,
//                             endIndent: 10,
//                           )
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8,),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 24),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(
//                             onPressed: (){
//
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black.withValues(alpha: 0.4),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Image.asset("assets/images/google_logo.png", width: 15, height: 15,),
//                                 Text("oogle", style: TextStyle(color: Colors.white),),
//                               ],
//                             )
//                         ),
//                         SizedBox(width: 9,),
//                         ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black.withValues(alpha: 0.4),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             onPressed: (){
//
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Icon(Icons.apple, color: Colors.white,),
//                                 Text("Apple", style: TextStyle(color: Colors.white),),
//                               ],
//                             )
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16,)
//                 ],
//               )
//           ),
//         ),
//       ),
//     );
//   }
// }
