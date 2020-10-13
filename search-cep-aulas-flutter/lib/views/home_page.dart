import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:search_cep/themes/lightblue.dart';
import 'package:search_cep/themes/purpledark.dart';
import 'package:share/share.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Required:
  GlobalKey<FormState> _formResult = GlobalKey<FormState>();

  // All the TextEditingControllers we need for fancy input thingies
  // (I was just relying on Text() and the Map() from cep object earlier, they look ugly)
  var _resultRua = TextEditingController();
  var _resultComplemento = TextEditingController();
  var _resultBairro = TextEditingController();
  var _resultLocalidade = TextEditingController();
  var _resultUF = TextEditingController();
  var _resultUnidade = TextEditingController();
  var _resultIBGE= TextEditingController();
  var _resultGIA = TextEditingController();

  bool _loading = false;
  bool _enableField = true;
  String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
                  title: Text('Consultar CEP'),
                  actions: <Widget>[IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    onPressed: () {
                      if (Theme.of(context).brightness == Brightness.light){
                        DynamicTheme.of(context).setThemeData(myPurpleDarkTheme);
                      }
                      else{
                        DynamicTheme.of(context).setThemeData(myLightBlueTheme);                        
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: (){
                      Share.share("CEP: ${_searchCepController.text}");
                    },
                  )],
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: _buildSearchCepTextField(),
                      ),
                      _buildSearchCepButton(),
                      // This is not pretty but designers will take care of it
                      SizedBox(height: 10),
                      _buildResultForm(),
                    ],
                  ),
                ),
              );
  }

  Widget _buildResultForm(){

    return Form(
      key: _formResult,
      child: Column(
        children: <Widget>[
          TextFormField(controller: _resultRua,  decoration: InputDecoration(icon: Icon(Icons.streetview), labelText: 'Rua'),),
          TextFormField(controller: _resultBairro, decoration: InputDecoration(icon: Icon(Icons.map), labelText: 'Bairro'),),
          TextFormField(controller: _resultComplemento, decoration: InputDecoration(icon: Icon(Icons.location_city), labelText: 'Complemento'),),
          TextFormField(controller: _resultLocalidade, decoration: InputDecoration(icon: Icon(Icons.location_city), labelText: 'Localidade'),),
          TextFormField(controller: _resultUF, decoration: InputDecoration(icon: Icon(Icons.flag), labelText: 'Unidade Federativa'),),
          TextFormField(controller: _resultUnidade, decoration: InputDecoration(icon: Icon(Icons.info_outline), labelText: 'Unidade'),),
          TextFormField(controller: _resultIBGE, decoration: InputDecoration(icon: Icon(Icons.person), labelText: 'IBGE'),),
          TextFormField(controller: _resultGIA, decoration: InputDecoration(icon: Icon(Icons.info), labelText: 'GIA'),),
        ],
      ),
    );
  }

  Widget _buildSearchCepTextField() {

    return TextFormField(
      decoration: InputDecoration(labelText: 'Cep'),
      keyboardType: TextInputType.number,
      autofocus: true,
      controller: _searchCepController,
      enabled: _enableField,
      autovalidate: false,
      validator: (String str) {
        // Remove the "-"" in case we have one
        str = str.replaceAll(r'-', r'');

        if (str == ''){
          // there's probably a more logical way of handling an empty field
          clearResultFields();
          return '';
        }
        else if(str.length != 8){
          clearResultFields();
          return 'Digite um CEP válido!';
        }
        else if (num.tryParse(str) == null){
          clearResultFields();
          return 'CEP deve contar apenas números e um traço!';
        }
        else
          return null;
      },
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: (){
          if (_formKey.currentState.validate()){
            _searchCep();
          }
        },
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  void clearResultFields(){
        setState(() {
        _resultBairro.text = "";
        _resultComplemento.text = "";
        _resultGIA.text = "";
        _resultIBGE.text = "";
        _resultLocalidade.text = "";
        _resultRua.text = "";
        _resultUF.text = "";
        _resultUnidade.text = "";
      });
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);

    if (resultCep != null){
      setState(() {
        _resultBairro.text = resultCep.bairro;
        _resultComplemento.text = resultCep.complemento;
        _resultGIA.text = resultCep.gia;
        _resultIBGE.text = resultCep.ibge;
        _resultLocalidade.text = resultCep.localidade;
        _resultRua.text = resultCep.logradouro;
        _resultUF.text = resultCep.uf;
        _resultUnidade.text = resultCep.unidade;
      });
    }
    else{
      Flushbar(
        message: "CEP não pode ser buscado!",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5),
        icon: Icon(
          Icons.info_outline,
          size: 30,
          color: Theme.of(context).errorColor
        ),
      )..show(context);
      clearResultFields();
    }
    _searching(false);
  }
}
