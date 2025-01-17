import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    return Drawer(
      child: Column(
        children: [
          // HEADER
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Row(
              children: const [],
            ),
          ),

          // PROFILE
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(
                    Icons.person,
                  ),
                ),
                Text(
                  MyTools.capitalizeEachWord(strings.profile),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.profileScreen);
            },
          ),

          // SETTINGS
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(
                    Icons.settings,
                  ),
                ),
                Text(
                  MyTools.capitalizeEachWord(strings.settings),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.settingsScreen);
            },
          ),

          // HELP
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(
                    Icons.help,
                  ),
                ),
                Text(
                  MyTools.capitalizeEachWord(strings.help),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.helpScreen);
            },
          ),

          // LOG OUT
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(
                    Icons.logout,
                  ),
                ),
                Text(
                  MyTools.capitalizeEachWord(strings.logOut),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            onTap: () {
              MyAuthProvider.of(context)
                  .logOut()
                  .then((value) => context.goNamed(MyRoutes.loginScreen));
            },
          ),
          const SizedBox(
            height: MyMeasurements.distanceFromEdge,
          ),
        ],
      ),
    );
  }

  void closeDrawer(BuildContext context) => Navigator.of(context).pop();

  void goToScreen(BuildContext context, String screenName) =>
      GoRouter.of(context).pushNamed(screenName);
}
