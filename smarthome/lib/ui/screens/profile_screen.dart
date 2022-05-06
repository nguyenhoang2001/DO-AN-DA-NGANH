import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/providers.dart';
import '../models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.darkmode}) : super(key: key);
  static MaterialPage page(bool darkmode) {
    return MaterialPage(
      name: ThermometerPage.profilePath,
      key: ValueKey(ThermometerPage.profilePath),
      child: ProfileScreen(darkmode: darkmode),
    );
  }

  bool darkmode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    user = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const AuthPage()
        : Scaffold(
            appBar: AppBar(
              title:
                  Text('Profile', style: Theme.of(context).textTheme.headline2),
              leading: IconButton(
                  onPressed: () {
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .tapOnProfile(false);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                buildProfile(),
                Expanded(child: buildMenu()),
              ],
            ),
          );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        ListTile(
          title: const Text('View HCMUT Website!'),
          onTap: () {
            // TODO: Open raywenderlich.com webview
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .tapOnHCMUT(true);
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            Provider.of<GoogleSignInProvider>(context, listen: false).logout();
            // Provider.of<AppStateManager>(context, listen: false).logout();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
            value: widget.darkmode,
            onChanged: (value) {
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .darkMode = value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    // var currentUser = widget.customer.user;
    return Column(
      children: [
        CircleImage(
            imageRadius: 60,
            imageProvider: NetworkImage(user!.photoURL ??
                'https://thumbs.dreamstime.com/z/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg')),
        // Text(currentUser != null ? currentUser.displayName! : 'User',
        //     style: Theme.of(context).textTheme.headline5),
        // Text(currentUser != null ? currentUser.email! : 'abc@example.com;',
        //     style: Theme.of(context).textTheme.headline5)
        Text(user!.displayName ?? 'User',
            style: Theme.of(context).textTheme.headline5),
        Text(user!.email ?? 'abc@example.com',
            style: Theme.of(context).textTheme.headline5),
      ],
    );
  }
}
