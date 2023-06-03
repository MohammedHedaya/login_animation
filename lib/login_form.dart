
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var animationLink = 'assets/login.riv';
 late SMITrigger failTrigger , successTrigger;
 late SMIBool isChecking , isHandsUp;
 late SMINumber lookNum;
 Artboard? artboard;
 late StateMachineController? stateMachineController;

 @override
 void initState(){
   super.initState();
   initArtboard();
 }

  initArtboard(){
   rootBundle.load(animationLink).then((value) {
     final file = RiveFile.import(value);
     final art = file.mainArtboard;
     stateMachineController = StateMachineController.fromArtboard(art, "Login Machine")!;
   art.addController(stateMachineController!);
   for (var element in stateMachineController!.inputs){
     if (element.name == "isChecking"){
       isChecking = element as SMIBool;
     }
    else if(element.name == 'isHandsUp'){
       isHandsUp = element as SMIBool;
     }
    else if (element.name == "trigSuccess"){
       successTrigger = element as SMITrigger;
     }
     else if (element.name == "trigFail"){
       failTrigger = element as SMITrigger;
     }else if (element.name == 'numLook'){
       lookNum = element as SMINumber;
     }
   }
     setState(() {
       artboard= art;
     });
   });
  }
  checking(){
   isHandsUp.change(false);
   isChecking.change(true);
   lookNum.change(0);
  }
  moveEyes(value){
   lookNum.change(value.length.toDouble());
  }
  handsUp(){
   isHandsUp.change(true);
   isChecking.change(false);
  }
  login(){
   isHandsUp.change(false);
   isChecking.change(false);
   if (emailController.text=='admin'&& passwordController.text=='admin'){
     successTrigger.fire();
   }else{
     failTrigger.fire();
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (artboard != null)
            SizedBox(
              width: 400,
              height: 350,
              child: Rive(artboard: artboard!),
            ),
            Container(
              alignment: Alignment.center,
              width: 400,
              padding:const EdgeInsets.only(bottom: 15),
              margin: const EdgeInsets.only(bottom: 15*4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                           const SizedBox(height: 15 *2),
                         TextField(
                           onTap: checking,
                          onChanged: ((value) => moveEyes(value)),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 14),
                          cursorColor: const Color(0xffb04863),
                          decoration: const InputDecoration(
                            hintText: "Email || UserName",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusColor: Color(0xffb04863),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb04863),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          onTap: handsUp,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(fontSize: 14),
                          cursorColor: const Color(0xffb04863),
                          decoration: const InputDecoration(
                            hintText: "Password",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusColor: Color(0xffb04863),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb04863),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffb04863),
                            ),
                          child: const Text("Login"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}