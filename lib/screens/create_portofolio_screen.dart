import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:protobuddy/providers/crud_provider.dart';
import 'package:protobuddy/providers/image_provider.dart';
import 'package:protobuddy/widgets/colors.dart';

class CreateProto extends StatelessWidget {
  final specificationController = TextEditingController();
  final creatorController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final image = ref.watch(imageProvider).image;
      return Scaffold(
        backgroundColor: ColorConstants.primaryColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            icon: Icon(
              Icons.arrow_back,
              color: ColorConstants.primaryColor,
            ),
          ),
          backgroundColor: ColorConstants.secondaryColor,
          title: Text(
            'Create a protofolio',
            style: TextStyle(color: ColorConstants.primaryColor),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  _form.currentState!.save();
                  FocusScope.of(context).unfocus();
                  if (image == null) {
                    Get.defaultDialog(
                        backgroundColor: ColorConstants.secondaryColor,
                        content: Text(
                          'Select an image',
                          style: TextStyle(color: ColorConstants.primaryColor),
                        ),
                        title: 'IMAGE MISSING',
                        titleStyle:
                            TextStyle(color: ColorConstants.primaryColor),
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
                    final response = await ref.read(crudProvider).addPost(
                        creatorName: creatorController.text.trim(),
                        speciality: specificationController.text.trim(),
                        education: educationController.text.trim(),
                        experience: experienceController.text.trim(),
                        description: descriptionController.text.trim(),
                        userId: userId,
                        file: image);
                    if (response != 'success') {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: ColorConstants.secondaryColor,
                          duration: Duration(seconds: 1),
                          content: Text(
                            response,
                            style:
                                TextStyle(color: ColorConstants.primaryColor),
                          )));
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: Icon(
                  Icons.upload,
                  color: ColorConstants.primaryColor,
                ))
          ],
        ),
        body: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: creatorController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT CREATOR NAME';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      label: Text('Creator Name'),
                      labelStyle:
                          TextStyle(color: ColorConstants.secondaryColor),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorConstants.secondaryColor),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: specificationController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT SPECIALITY';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      label: Text('Speciality'),
                      labelStyle:
                          TextStyle(color: ColorConstants.secondaryColor),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorConstants.secondaryColor),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: educationController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT EDUCATION';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      label: Text('Education'),
                      labelStyle:
                          TextStyle(color: ColorConstants.secondaryColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: experienceController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT EXPERIENCE';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      label: Text('Hand on experience'),
                      labelStyle:
                          TextStyle(color: ColorConstants.secondaryColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'PLEASE INPUT DESCRIPTION';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      label: Text(
                        'Project Description',
                        style: TextStyle(color: ColorConstants.secondaryColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      );
    }));
  }
}
