import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/models/lost_object.dart';
import 'package:lost_and_found/utils/common.dart';
import 'package:lost_and_found/widgets/circle_network_image.dart';
import 'package:lost_and_found/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      title: Text('Home'),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lost_objects').snapshots(),
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
      title: Text(lostObject?.title ?? ''),
      subtitle: Text(lostObject?.description ?? ''),
      leading: CircleNetworkImage(
        initials: lostObject?.getInitials(),
        pictureUrl: lostObject.pictureUrl,
      ),
    );
  }
}
