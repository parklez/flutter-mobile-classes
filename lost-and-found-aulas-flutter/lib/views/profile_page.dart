
import 'package:flutter/material.dart';
import 'package:lost_and_found/widgets/custom_drawer.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Perfil'),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
        child: Column(
          children: <Widget>[
            _createNameTextField(),
          ],
        ),
      ),
    );
  }

  Widget _createNameTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome', icon: Icon(Icons.person)),
    );
  }

}
