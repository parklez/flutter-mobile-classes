/*
[x] Adicionar botões (Toggle ouRadio button) para escolha de gênero (masculino / feminino);
[X] Corrigir o calculo de acordo com o gênero (masculino e feminino);
[x] Criar um classe Pessoa com os atributos (peso, altura e gênero), criar métodos para calcular IMC e classificar;
[X] Refatorar o código do aplicativo para utilizar a classe Pessoa;
[X] Aplicar uma escala de cores para o resultado da classificação do IMC;
[X] Aumentar o texto do resultado do IMC (número) e também colocar em negrito.
*/
import 'package:flutter/material.dart';


class Pessoa{
  double peso;
  double altura;
  int genero = 0;

  double calcularIMC(){
    return this.peso / (this.altura/100 * this.altura/100);
  }

  Color buscarCorIdeal(double imc) {
    // https://calculefacil.com/calculo-imc/
    Color cor;
    if (this.genero == 0){
      if (imc < 20.7)
        cor = Colors.blue;
      else if (imc >= 20.7 && imc <= 26.4)
        cor = Colors.green;
      else if (imc >= 26.5 && imc <= 27.8)
        cor = Colors.lime;
      else if (imc >= 27.9 && imc <= 31.1)
        cor = Colors.yellow;
      else
        cor = Colors.red;
    }
    else{
      if (imc < 19.1)
        cor = Colors.blue;
      else if (imc >= 19.1 && imc <= 25.8)
        cor = Colors.green;
      else if (imc >= 25.9 && imc <= 27.3)
        cor = Colors.lime;
      else if (imc >= 27.4 && imc <= 32.3)
        cor = Colors.yellow;
      else
        cor = Colors.red;
    }
    return cor;
  }

  String classificar(double imc){
    String _result = '';

    if (this.genero == 0){
        // https://indicedemassacorporal.com/movel/calculo-imc-masculino.html
        if (imc < 20.7)
          _result += "Abaixo do peso";
        else if (imc >= 20.7 && imc <= 26.4)
          _result += "Peso ideal";
        else if (imc >= 26.5 && imc <= 27.8)
          _result += "Levemente acima do peso";
        else if (imc >= 27.9 && imc <= 31.1)
          _result += "Acima do peso";
        else
          _result += "Obesidade";
    }
    else{
      // https://indicedemassacorporal.com/movel/calculo-imc-feminino.html
      if (imc < 19.1)
        _result += "Abaixo do peso";
      else if (imc >= 19.1 && imc <= 25.8)
        _result += "Peso ideal";
      else if (imc >= 25.9 && imc <= 27.3)
        _result += "Levemente acima do peso";
      else if (imc >= 27.4 && imc <= 32.3)
        _result += "Acima do peso";
      else
        _result += "Obesidade";
    }
    return _result;
  }
}
  
void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));
  
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
  
class _HomeState extends State<Home> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Pessoa usuario = Pessoa();
  String imcNumber = "0.0";
  String imcMessage = "Por favor, preencha os campos.";
  Color imcColor = Colors.grey;
  bool isResultOnScreen = false;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    isResultOnScreen = false;
    setState(() {
      imcMessage = 'Por favor, preencha os campos.';
      imcNumber = "0.0";
      imcColor = Colors.grey;
    });
  }

  void _handleGenderCalculation(int value){
    // This function clears the result and sets the new gender value.
    // 0 = Male, 1 = Female

    setState((){
      if (isResultOnScreen){
        usuario.genero = value;
        // If said result exists, that means height/weight are stored already, therefore:
        imcMessage = usuario.classificar(usuario.calcularIMC());
        imcNumber = usuario.calcularIMC().toStringAsPrecision(3);
        imcColor = usuario.buscarCorIdeal(usuario.calcularIMC());
      }
    });
    usuario.genero = value;
  }

  TextFormField customMeme(String label, String warning, TextEditingController controller) {
  // This function returns a custom TextFormField, cool isn't it? I wonder if this should've been a class instead...
  return TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: label),
                  controller: controller,
                  validator: (text) {
                    return text.isEmpty ? warning : null;
                  },
                );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculadora de IMC'),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                resetFields();
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    customMeme("Altura (cm)", "Digite uma altura!", _heightController),
                    customMeme("Peso (kg)", "Digite um peso!", _weightController),

                    // Some padding for the Text
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text('Gênero:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0,
                      color: Colors.grey),
                      ),
                      ),

                    // Row for Radio Buttons and Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(value: 0,
                        groupValue: usuario.genero,
                        onChanged: _handleGenderCalculation,
                        ),
                        Text('Masculino'),
                        Radio(value: 1,
                        groupValue: usuario.genero,
                        onChanged: _handleGenderCalculation,
                        ),
                        Text('Feminino'),
                    ],),

                    // Result shenanigans
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(imcNumber, textAlign: TextAlign.center, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold))
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      // One dark shadow looks awful but maybe using two of them diagonally could make text readable or something, code:
                      // shadows: [Shadow(color: Colors.black, offset: Offset(1.0, 1.0), blurRadius: 5)]
                      child: Text(imcMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: imcColor, ))
                    ),

                    // Button
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 36.0),
                        child: Container(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              // todo: onPressed code could be rewritten somewhere
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  usuario.altura = double.parse(_heightController.text);
                                  usuario.peso = double.parse(_weightController.text);
                                  double resultado = usuario.calcularIMC();
                                  setState((){
                                    imcMessage = usuario.classificar(resultado);
                                    imcNumber = usuario.calcularIMC().toStringAsPrecision(3);
                                    imcColor = usuario.buscarCorIdeal(usuario.calcularIMC());
                                    isResultOnScreen = true;
                                  });
                                }
                              },
                              child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
                            ))),
                            
                  ],
                ))));
  }
}