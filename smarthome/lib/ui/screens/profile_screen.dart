import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/providers.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.customer}) : super(key: key);
  Customer customer;
  static MaterialPage page(Customer user) {
    return MaterialPage(
        name: ThermometerPage.profilePath,
        key: ValueKey(ThermometerPage.profilePath),
        child: ProfileScreen(customer: user));
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.headline2),
        leading: IconButton(
            onPressed: () =>
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .tapOnProfile(false),
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
            // TODO: Logout user
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
            value: widget.customer.darkMode,
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
    var currentUser = widget.customer.user;
    return Column(
      children: [
        CircleImage(
            imageRadius: 60,
            imageProvider: currentUser != null
                ? NetworkImage(currentUser.photoURL!)
                : null),
        // Text(currentUser != null ? currentUser.displayName! : 'User',
        //     style: Theme.of(context).textTheme.headline5),
        // Text(currentUser != null ? currentUser.email! : 'abc@example.com;',
        //     style: Theme.of(context).textTheme.headline5)
        Text(currentUser!.displayName!,
            style: Theme.of(context).textTheme.headline5),
        Text(currentUser.email!, style: Theme.of(context).textTheme.headline5)
      ],
    );
  }
}
