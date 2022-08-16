import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:protobuddy/models/post_proto.dart';

import 'package:protobuddy/models/user.dart';
import 'package:protobuddy/providers/crud_provider.dart';
import 'package:protobuddy/screens/create_portofolio_screen.dart';
import 'package:protobuddy/widgets/colors.dart';
import 'package:protobuddy/widgets/drawer_widget.dart';
import 'package:protobuddy/widgets/updatepage.dart';

class HomeScreen extends StatelessWidget {
  late User user;
  final userId = auth.FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userData = ref.watch(userStream);
      final postData = ref.watch(postStream);

      var size = MediaQuery.of(context).size;

      return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: ColorConstants.secondaryColor),
          elevation: 0,
        ),
        backgroundColor: ColorConstants.primaryColor,
        body: ListView(
          children: [
            Container(
              height: 600,
              child: postData.when(
                data: (data) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        //user = data.firstWhere((element) => element.userId == userId);
                        final dat = data[index];
                        return GestureDetector(
                          onTap: () {},
                          onLongPress: () {
                            if (userId == dat.userId) {
                              Get.defaultDialog(
                                  title: 'Customize Portofolio',
                                  content: Text('Edit or remove post'),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Get.to(() => UpdatePorto(dat),
                                            transition: Transition.leftToRight);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Get.defaultDialog(
                                            title: 'Are you sure',
                                            content: Text(
                                                'you want to remove  this post'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    ref
                                                        .read(crudProvider)
                                                        .removePost(
                                                            postId: dat.id,
                                                            imageId:
                                                                dat.imageId);
                                                  },
                                                  child: Text('yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('No'))
                                            ]);
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ]);
                            }
                          },
                          child: Card(
                            child: Container(
                                child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      constraints: BoxConstraints(
                                        maxHeight: 200,
                                      ),
                                      width: size.width / 2,
                                      child: Image.network(
                                        dat.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: size.width / 2.8),
                                            child: Text(
                                              dat.description,
                                              maxLines: 7,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              CircleAvatar(),
                                              Text(
                                                dat.creatorName,
                                                style: TextStyle(fontSize: 21),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (userId != dat.userId)
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (dat.likData.usernames
                                                    .contains(user.username)) {
                                                } else {
                                                  final newData = Like(
                                                      likes:
                                                          dat.likData.likes + 1,
                                                      usernames: [
                                                        ...dat
                                                            .likData.usernames,
                                                        user.username
                                                      ]);

                                                  ref
                                                      .read(crudProvider)
                                                      .likePost(
                                                          postId: dat.id,
                                                          likeData: newData);
                                                }
                                              },
                                              icon:
                                                  Icon(Icons.favorite_outline)),
                                          if (dat.likData.likes != 0)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child:
                                                  Text('${dat.likData.likes}'),
                                            ),
                                        ],
                                      ),
                                  ],
                                )
                              ],
                            )),
                          ),
                        );
                      });
                },
                error: (error, stackTrace) => Text('$error'),
                loading: () => Container(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorConstants.secondaryColor,
          onPressed: (() {
            Get.to(() => CreateProto());
          }),
          child: Icon(
            Icons.add,
            color: ColorConstants.primaryColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}



// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:protobuddy/providers/crud_provider.dart';
// import 'package:protobuddy/screens/create_portofolio_screen.dart';
// import 'package:protobuddy/widgets/colors.dart';
// import 'package:protobuddy/widgets/drawer_widget.dart';
// import 'package:protobuddy/widgets/updatepage.dart';

// class HomeScreen extends StatelessWidget {
//   late User user;
//   final userId = auth.FirebaseAuth.instance.currentUser!.uid;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, child) {
//       final userData = ref.watch(userStream);
//       final postData = ref.watch(postStream);

//       return Scaffold(
//         drawer: DrawerWidget(),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           iconTheme: IconThemeData(color: ColorConstants.secondaryColor),
//           elevation: 0,
//         ),
//         backgroundColor: ColorConstants.primaryColor,
//         body: ListView(
//           children: [
//             Container(
//               height: 600,
//               child: postData.when(
//                 data: (data) {
//                   return ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: data.length,
//                       itemBuilder: (context, index) {
//                         // user = data.firstWhere((element) => element.userId == userId);
//                         final dat = data[index];
//                         return GestureDetector(
//                           onLongPress: (){},
//                           child: Card(
//                             child: Padding(
//                               padding:
//                                   EdgeInsets.only(top: 20, left: 10, right: 10),
//                               child: Container(
//                                   child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         width: 250,
//                                         height: 27,
//                                         child: Text(
//                                           dat.creatorName,
//                                         ),
//                                       ),
//                                       if (userId == dat.userId)
//                                         IconButton(
//                                             onPressed: () {
//                                               Get.defaultDialog(
//                                                   title: 'Customize Portofolio',
//                                                   content:
//                                                       Text('Edit or remove post'),
//                                                   actions: [
//                                                     IconButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop();
//                                                         Get.to(
//                                                             () =>
//                                                                 UpdatePorto(dat),
//                                                             transition: Transition
//                                                                 .leftToRight);
//                                                       },
//                                                       icon: Icon(Icons.edit),
//                                                     ),
//                                                     IconButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop();
//                                                         Get.defaultDialog(
//                                                             title: 'Are you sure',
//                                                             content: Text(
//                                                                 'you want to remove  this post'),
//                                                             actions: [
//                                                               TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(
//                                                                             context)
//                                                                         .pop();
//                                                                     ref.read(crudProvider).removePost(
//                                                                         postId: dat
//                                                                             .id,
//                                                                         imageId: dat
//                                                                             .imageId);
//                                                                   },
//                                                                   child: Text(
//                                                                       'yes')),
//                                                               TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(
//                                                                             context)
//                                                                         .pop();
//                                                                   },
//                                                                   child:
//                                                                       Text('No'))
//                                                             ]);
//                                                       },
//                                                       icon: Icon(Icons.delete),
//                                                     )
//                                                   ]);
//                                             },
//                                             icon: Icon(
//                                               Icons.more_horiz_rounded,
//                                             )),
//                                     ],
//                                   ),
//                                   Container(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Image.network(
//                                         dat.imageUrl,
//                                         fit: BoxFit.cover,
//                                       )),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Flexible(child: Text(dat.description)),
//                                       if (userId != dat.userId)
//                                         Row(
//                                           children: [
//                                             IconButton(
//                                                 onPressed: () {},
//                                                 icon: Icon(
//                                                     Icons.thumb_up_alt_outlined)),
//                                             if (dat.likData.likes != 0)
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     right: 10),
//                                                 child:
//                                                     Text('${dat.likData.likes}'),
//                                               ),
//                                           ],
//                                         ),
//                                     ],
//                                   )
//                                 ],
//                               )),
//                             ),
//                           ),
//                         );
//                       });
//                 },
//                 error: (error, stackTrace) => Text('$error'),
//                 loading: () => Container(),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: ColorConstants.secondaryColor,
//           onPressed: (() {
//             Get.to(() => CreateProto());
//           }),
//           child: Icon(
//             Icons.add,
//             color: ColorConstants.primaryColor,
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       );
//     });
//   }
// }
