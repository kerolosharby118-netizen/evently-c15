import 'package:evently_c15/data/firestore_utils.dart';
import 'package:evently_c15/model/user_dm.dart';
import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:evently_c15/ui/utils/dialog_utils.dart';
import 'package:evently_c15/ui/widgets/custom_button.dart';
import 'package:evently_c15/ui/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              AppAssets.appVerticalLogo,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            CustomTextField(
              hint: 'User name',
              controller: userNameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Password',
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Re password',
              isPassword: true,
            ),
            const SizedBox(height: 32),
            buildCreateAccountButton(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Hava an account",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Login"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildCreateAccountButton(BuildContext context) => SizedBox(
        width: double.infinity,
        child: CustomButton(
          onClick: () async {
            showLoading(context);
            try {
              var userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);
              UserDM.currentUser = UserDM(
                  id: userCredential.user!.uid,
                  name: userNameController.text,
                  email: emailController.text,
                  favoriteEvents: []);
              addUserToFirestore(UserDM.currentUser!);
              Navigator.pop(context);
              ///Hide loading
              Navigator.push(context, AppRoutes.home);
            } on FirebaseAuthException catch (e) {
              var message = "Something went wrong, Please try again later!";
              if (e.code == 'weak-password') {
                message = 'The password provided is too weak.';
              } else if (e.code == 'email-already-in-use') {
                message = 'The account already exists for that email.';
              }
              Navigator.pop(context);

              ///Hide loading
              showMessage(context, content: message, posButtonTitle: "ok");
            }
          },
          text: "Register",
        ),
      );
}
