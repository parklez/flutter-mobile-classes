import 'package:chatbot/models/chat_message.dart';
import 'package:chatbot/widgets/chat_message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Ice creamu tips 🍦'),
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 5.0),
          _buildUserInput(),
        ],
      ),
    );
  }

  // Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      child: ListView.separated(
        // I don't get why I can't get spaces between items :thinking:
        // https://api.flutter.dev/flutter/widgets/ListView/ListView.separated.html
        separatorBuilder: (_, int index) => Divider(height: 5),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  Future _dialogFlowRequest({String query}) async {
    // Adiciona uma mensagem temporária na lista
    _addMessage(
        name: 'Vanilla',
        text: 'Writing...',
        type: ChatMessageType.received);

    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        name: 'Vanilla',
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(name: 'Kleber Andrade', text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(
        text: text, name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);  
    }
  }

  // Campo para escrever a mensagem
  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: _controllerText,
        style: TextStyle(color: Colors.black),
        decoration: new InputDecoration.collapsed(
          fillColor: Colors.black,
          hintText: "Enviar mensagem",
        ),
      ),
    );
  }

  // Botão para enviar a mensagem
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
          onPressed: () {
            if (_controllerText.text.isNotEmpty) {
              _sendMessage(text: _controllerText.text);
            }
          }),
    );
  }

  // Monta uma linha com o campo de text e o botão de enviao
  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(40.0),
          right: Radius.circular(40.0)
        )
      ),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}
