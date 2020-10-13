import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/models/lost_object.dart';
import 'package:lost_and_found/models/user.dart';
import 'package:lost_and_found/services/auth.dart';
import 'package:lost_and_found/utils/common.dart';
import 'package:lost_and_found/views/lost_object_detail_page.dart';
import 'package:lost_and_found/widgets/circle_network_image.dart';
import 'package:lost_and_found/widgets/custom_drawer.dart';

class FoundPage extends StatefulWidget {
  static const String routeName = '/found';
  @override
  _FoundPageState createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage> {
  User _currentUser;

  @override
  void initState() {
    super.initState();
    Auth.getUserLocal().then((user) {
      setState(() {
        _currentUser = user;
        print('Current user: ${_currentUser.toJson()}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Achados'),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      label: Text('ACHEI'),
      icon: Icon(Icons.add),
      onPressed: _foundObject,
    );
  }

  Future _foundObject() async {
    await Navigator.of(context).pushNamed(LostObjectDetailPage.routeName);
    Flushbar(
      title: 'Salvar',
      message: 'Registro do item realizado com sucesso!',
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget _buildBody() {
    if (_currentUser == null) return Common.progressContainer();

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('lost_objects')
          .where('finderUserId', isEqualTo: _currentUser.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Common.errorContainer(error: snapshot.error);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Common.progressContainer();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data.documents.length == 0)
              return Common.emptyContainer(
                  message: "Nenhum objeto encontrado!");
            else
              return ListView(
                children: snapshot.data.documents.map(_buildCard).toList(),
              );
        }
        return null;
      },
    );
  }

  Widget _buildCard(document) {
    final lostObject = LostObject.fromDocument(document);
    return ListTile(
      title: Text(lostObject.title),
      subtitle: Text(lostObject.description),
      leading: CircleNetworkImage(
        initials: lostObject?.getInitials(),
        pictureUrl: lostObject.pictureUrl,
      ),
    );
  }
}
