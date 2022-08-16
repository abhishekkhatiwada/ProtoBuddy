import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:protobuddy/providers/auth_provider.dart';
import 'package:protobuddy/providers/image_provider.dart';
import 'package:protobuddy/providers/login_provider.dart';
import 'package:protobuddy/widgets/colors.dart';

class AuthScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Consumer(builder: (context, ref, child) {
        final isLogin = ref.watch(loginProvider);
        final image = ref.watch(imageProvider).image;
        final isLoad = ref.watch(loadingProvider);
        return Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView(children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  isLogin ? 'Login Page' : 'SignUp Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isLogin == false)
                TextFormField(
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT USERNAME';
                    } else if (value.length > 15) {
                      return 'USERNAME SHOULD BE LESS THAN 15 CHARACTERS';
                    }
                    return null;
                  }),
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: Text('Username'),
                      labelStyle:
                          TextStyle(color: ColorConstants.secondaryColor)),
                ),
              const SizedBox(height: 20),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'PLEASE INPUT EMAIL';
                  } else if (!value.contains('@')) {
                    return 'ENTER VALID EMAILADDRESS';
                  }
                  return null;
                }),
                controller: mailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text('Email'),
                    labelStyle:
                        TextStyle(color: ColorConstants.secondaryColor)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'PLEASE INPUT PASSWORD';
                  }
                  return null;
                }),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text('Password'),
                    labelStyle:
                        TextStyle(color: ColorConstants.secondaryColor)),
              ),
              const SizedBox(height: 20),
              if (isLogin == false)
                InkWell(
                  onTap: (() {
                    ref.read(imageProvider).imagePicker();
                  }),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.amber
                      ),
                      child: image == null
                          ? Center(
                              child: Text(
                              'Select an image',
                              style: TextStyle(
                                  color: ColorConstants.secondaryColor),
                            ))
                          : Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            )),
                ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColorConstants.secondaryColor),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      _form.currentState!.save();
                      if (_form.currentState!.validate()) {
                        if (isLogin) {
                          ref.read(loadingProvider.notifier).toggle();
                          final response =
                              await ref.read(authProvider).userSignIn(
                                    email: mailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                          if (response != 'success') {
                            ref.read(loadingProvider.notifier).toggle();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: ColorConstants.secondaryColor,
                                duration: Duration(seconds: 1),
                                content: Text(
                                  response,
                                  style: TextStyle(
                                      color: ColorConstants.primaryColor),
                                )));
                          }
                        } else {
                          if (image == null) {
                            Get.defaultDialog(
                                backgroundColor: ColorConstants.secondaryColor,
                                content: Text(
                                  'Select an image',
                                  style: TextStyle(
                                      color: ColorConstants.primaryColor),
                                ),
                                title: 'IMAGE MISSING',
                                titleStyle: TextStyle(
                                    color: ColorConstants.primaryColor),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: ColorConstants.primaryColor),
                                      ))
                                ]);
                          } else {
                            ref.read(loadingProvider.notifier).toggle();
                            final response = await ref
                                .read(authProvider)
                                .userSignUp(
                                    username: nameController.text.trim(),
                                    email: mailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    file: image);
                            if (response != 'success') {
                              ref.read(loadingProvider.notifier).toggle();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          ColorConstants.secondaryColor,
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                        response,
                                        style: TextStyle(
                                            color: ColorConstants.primaryColor),
                                      )));
                            }
                          }
                        }
                      }
                    },
                    child: isLoad
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Loading...',
                                style: TextStyle(
                                    color: ColorConstants.primaryColor),
                              ),
                              SizedBox(width: 5),
                              CircularProgressIndicator(
                                color: ColorConstants.primaryColor,
                              )
                            ],
                          )
                        : Text(
                            'Submit',
                            style:
                                TextStyle(color: ColorConstants.primaryColor),
                          )),
              ),
              Row(
                children: [
                  Text(
                    isLogin
                        ? 'Don\'t have an account?'
                        : 'Already have an account?',
                    style: TextStyle(color: ColorConstants.secondaryColor),
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(loginProvider.notifier).toggle();
                      },
                      child: Text(
                        isLogin ? 'SignUp' : 'LogIn',
                        style: TextStyle(
                            color: ColorConstants.secondaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ))
                ],
              )
            ]),
          ),
        );
      }),
    );
  }
}
