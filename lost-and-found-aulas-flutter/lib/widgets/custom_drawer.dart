import 'package:flutter/material.dart';
import 'package:lost_and_found/models/user.dart';
import 'package:lost_and_found/services/auth.dart';
import 'package:lost_and_found/utils/common.dart';
import 'package:lost_and_found/views/about_page.dart';
import 'package:lost_and_found/views/found_page.dart';
import 'package:lost_and_found/views/home_page.dart';
import 'package:lost_and_found/views/profile_page.dart';
import 'package:lost_and_found/views/root_page.dart';
import 'package:lost_and_found/views/use_term_page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User _user = new User();

  @override
  void initState() {
    Auth.getUserLocal().then(_onGetUserLocalSuccess);
    super.initState();
  }

  void _onGetUserLocalSuccess(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _showHeader(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(ProfilePage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload),
            title: Text('Achados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(FoundPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre o projeto'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(AboutPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Termos de uso'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(UseTermPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () async {
              final result = await Common.showQuitDialog(context);
              if (result) {
                Auth.signOut();
                Navigator.pushReplacementNamed(context, RootPage.routeName);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _showHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(_user?.name ?? ""),
      accountEmail: Text(_user?.email ?? ""),
      currentAccountPicture:
          CircleAvatar(child: Text(_user?.getInitials() ?? '')),
    );
  }
}
