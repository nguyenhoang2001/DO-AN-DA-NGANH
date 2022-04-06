import 'package:flutter/material.dart';
import 'package:smarthome/ui/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.customer}) : super(key: key);
  Customer customer;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.headline2),
        leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
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
            // Provider.of<ProfileManager>(context, listen: false)
                // .tapOnRaywenderlich(true);
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            // TODO: Logout user
            // Provider.of<AppStateManager>(context, listen: false).logout()
            Provider.of<GoogleSignInProvider>(context,listen:false).logout();
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
              // Provider.of<ProfileManager>(context, listen: false).darkMode =
              //     value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
            imageRadius: 60,
            imageProvider: NetworkImage(widget.customer.user.photoURL!)),
        Text(widget.customer.user.displayName!,
            style: Theme.of(context).textTheme.headline5),
        Text(widget.customer.user.email!,
            style: Theme.of(context).textTheme.headline5)
      ],
    );
  }
}
