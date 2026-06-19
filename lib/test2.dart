// import 'package:flutter/material.dart';
// import 'features/auth/view/auth.dart';
// import 'test1.dart';
//
// class Login2 extends StatefulWidget {
//   const Login2({super.key});
//
//   @override
//   State<Login2> createState() => _Login2State();
// }
//
// class _Login2State extends State<Login2> {
//
//   final _formkey = GlobalKey<FormState>();
//   TextEditingController _passwordcontroller = TextEditingController();
//   TextEditingController _emailcontroller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/omi_preview.webp"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   Card(
//                     color: Colors.black.withValues(alpha: 0.4),
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
//                               "Log In",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepPurpleAccent,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Feilds(controller: _emailcontroller, type: "Email"),
//                             const SizedBox(height: 16),
//                             Feilds(controller: _passwordcontroller, type: "Password"),
//                             const SizedBox(height: 24),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: ()async{
//                                   if(_formkey.currentState!.validate()){
//                                     print("validated");
//                                     String status = await Authentication().login(_emailcontroller.text, _passwordcontroller.text);
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
//                                   backgroundColor: Colors.deepPurpleAccent,
//                                 ),
//                                 child: Text(
//                                   "LOG IN",
//                                   style: const TextStyle(fontSize: 18.0, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "don't have an account? Sign up",
//                                 style: const TextStyle(color: Colors.deepPurpleAccent,),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Row(
//                     children: [
//                       Expanded(
//                           child: Divider(
//                             color: Colors.black,
//                             thickness: 1,
//                             indent: 10,
//                             endIndent: 10,
//                           )
//                       ),
//                       Text("OR", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 14),),
//                       Expanded(
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
