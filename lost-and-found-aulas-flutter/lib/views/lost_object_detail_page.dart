import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/models/lost_object.dart';
import 'package:lost_and_found/models/user.dart';
import 'package:lost_and_found/services/auth.dart';
import 'package:lost_and_found/widgets/image_area.dart';

class LostObjectDetailPage extends StatefulWidget {
  static const String routeName = '/lostobjectdetail';

  final LostObject lostObject;

  LostObjectDetailPage({this.lostObject});

  @override
  _LostObjectDetailPageState createState() => _LostObjectDetailPageState();
}

class _LostObjectDetailPageState extends State<LostObjectDetailPage> {
  final _formKey = new GlobalKey<FormState>();
  final _titleController = new TextEditingController();
  final _descriptionController = new TextEditingController();
  final _localController = new TextEditingController();
  final _dateController = new TextEditingController();

  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _initialDateValue = DateTime.now();

  User _localUser;
  String _urlPicture;
  LostObject _lostObject = new LostObject();

  @override
  void initState() {
    super.initState();

    if (widget.lostObject != null) {
      _lostObject = LostObject.fromMap(widget.lostObject.toMap());
      _titleController.text = _lostObject.title;
      _descriptionController.text = _lostObject.description;
      _localController.text = _lostObject.local;
      _dateController.text = _lostObject.date;
    }

    _loadLocalUser();
  }

  Future _loadLocalUser() async {
    final user = await Auth.getUserLocal();
    setState(() {
      _localUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Objeto Perdido'),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      label: Text('SALVAR'),
      icon: Icon(Icons.save),
      onPressed: _save,
    );
  }

  Future _save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _lostObject = new LostObject(
        title: _titleController.text,
        description: _descriptionController.text,
        local: _localController.text,
        date: _dateController.text,
        finderUserId: _localUser.userId,
        pictureUrl: _urlPicture,
      );

      print('Saving ${_lostObject.toJson()}');

      await Firestore.instance
          .collection('lost_objects')
          .add(_lostObject.toMap())
          .then(_onSaveDataSuccess)
          .catchError(_onSaveDataFailure);
    }
  }

  void _onSaveDataSuccess(result) {
    Navigator.pop(context, result);
  }

  void _onSaveDataFailure(error) {
    print('Error ${error.toString()})');

    Flushbar(
      title: 'Erro',
      message: error.toString(),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildImageArea(),
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildLocalTextField(),
            _buildDateTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    return ImageArea(
      userId: _localUser.userId,
      onCompleted: (url) {
        print('onCompleted with url: $url');
        _urlPicture = url;
      },
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      controller: _titleController,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Título',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (text) => text.isEmpty ? 'Título inválido' : null,
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: _descriptionController,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Descrição',
        prefixIcon: Icon(Icons.description),
      ),
      validator: (text) => text.isEmpty ? 'Descrição inválida' : null,
    );
  }

  Widget _buildLocalTextField() {
    return TextFormField(
      controller: _localController,
      minLines: 1,
      decoration: InputDecoration(
        labelText: 'Local',
        prefixIcon: Icon(Icons.location_on),
      ),
      validator: (text) => text.isEmpty ? 'Local inválido' : null,
    );
  }

  Widget _buildDateTextField() {
    return DateTimeField(
      controller: _dateController,
      format: _dateFormat,
      initialValue: _initialDateValue,
      decoration: InputDecoration(
        labelText: 'Data',
        prefixIcon: Icon(Icons.date_range),
      ),
      validator: (date) => date == null ? 'Data inválida' : null,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
      },
    );
  }
}
