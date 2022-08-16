import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:protobuddy/providers/auth_provider.dart';
import 'package:protobuddy/providers/crud_provider.dart';
import 'package:protobuddy/providers/login_provider.dart';
import 'package:protobuddy/screens/buy_sell.dart';
import 'package:protobuddy/screens/profile_screen.dart';
import 'package:protobuddy/widgets/colors.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer(builder: (context, ref, child) {
        final userData = ref.watch(singleUserStream);
        return userData.when(
            data: (data) {
              return Container(
                // width: MediaQuery.of(context).size.width * 0.5,
                color: ColorConstants.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            //color: ColorConstants.secondaryColor
                          ),
                          accountName: Text(
                            data.username,
                            style:
                                TextStyle(color: ColorConstants.secondaryColor),
                          ),
                          accountEmail: Text(
                            data.email,
                            style:
                                TextStyle(color: ColorConstants.secondaryColor),
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(data.imageUrl),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.secondaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: ColorConstants.primaryColor,
                          ),
                          title: Text(
                            'Profile',
                            style:
                                TextStyle(color: ColorConstants.primaryColor),
                          ),
                          onTap: (() {
                            Get.to(() => ProfileScreen());
                          }),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.secondaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: Icon(
                            Icons.attach_money_rounded,
                            color: ColorConstants.primaryColor,
                          ),
                          title: Text(
                            'Buy Sell',
                            style:
                                TextStyle(color: ColorConstants.primaryColor),
                          ),
                          onTap: (() {
                            Get.to(() => BuySell());
                          }),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.secondaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: ColorConstants.primaryColor,
                          ),
                          title: Text(
                            'Sign Out',
                            style:
                                TextStyle(color: ColorConstants.primaryColor),
                          ),
                          onTap: (() {
                            ref.read(loadingProvider.notifier).toggle();
                            ref.read(authProvider).userSignOut();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Text('$error'),
            loading: () => Container());
      }),
    );
  }
}
