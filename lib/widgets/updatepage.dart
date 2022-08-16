import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:protobuddy/models/post_proto.dart';
import 'package:protobuddy/providers/crud_provider.dart';
import 'package:protobuddy/providers/image_provider.dart';
import 'package:protobuddy/widgets/colors.dart';

class UpdatePorto extends StatelessWidget {
  final Postproto post;
  UpdatePorto(this.post);
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
            'Update a protofolio',
            style: TextStyle(color: ColorConstants.primaryColor),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  _form.currentState!.save();
                  SystemChannels.textInput.invokeMethod('TextIjnput.hide');
                  if (image == null) {
                    final response = await ref.read(crudProvider).updatePost(
                          creatorName: creatorController.text.trim(),
                          speciality: specificationController.text.trim(),
                          education: educationController.text.trim(),
                          experience: experienceController.text.trim(),
                          description: descriptionController.text.trim(),
                          postId: post.id,
                        );
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
                  } else {
                    final response = await ref.read(crudProvider).updatePost(
                        creatorName: creatorController.text.trim(),
                        speciality: specificationController.text.trim(),
                        education: educationController.text.trim(),
                        experience: experienceController.text.trim(),
                        description: descriptionController.text.trim(),
                        postId: post.id,
                        imageId: post.imageId,
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
                  controller: creatorController..text = post.creatorName,
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
                  controller: specificationController..text = post.speciality,
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
                  controller: educationController..text = post.education,
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
                  controller: experienceController..text = post.experience,
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
                  controller: descriptionController..text = post.description,
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
                          ? Image.network(post.imageUrl)
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
