/*
[x] Não deixar que seja possível ficar com pontos negativos ao clicar em (-1) e também não pode ultrapassar 12 pontos.
[X] Permitir de alguma forma que a partida seja reiniciada, sem zerar o número de vitórias
[X] Transformar o AlertDialog em modal para que somente desapareça da tela ao clicar em CANCEL ou OK. Uma dia, precisa utilizar o atributo barrierDismissible
[ ] Trocar os nomes dos usuários ao clicar em cima do nome (Text). Pode-se utilizar um GestureDetector e exibir um AlertDialog com um TextField. Exemplo de AlertDialog com TextField.
[X] Exibir uma notificação da mão de ferro: é a Mão de Onze especial, quando as duas duplas conseguem chegar a 11 pontos na partida. Todos os jogadores recebem as cartas “cobertas”, isto é, viradas para baixo, e deverão jogar assim. Quem vencer a mão, vence a partida
[x] Instale o plugin Screen e adicione um código para deixar a tela sempre ativa enquanto joga.
*/


import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _playerOne = Player(name: "Nós", score: 0, victories: 0);
  var _playerTwo = Player(name: "Eles", score: 0, victories: 0);

  TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetPlayers();
    
  }

  void _resetPlayer({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // brightness variable doesn't actually invert the icons at the very top /shrug
        backgroundColor: Colors.lightGreen,
        title: Text("Marcador Pontos (Truco)",
        style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showResetDialog(
                  title: 'Zerar',
                  message:
                      'Selecione a opção a ser zerada.',
                  partida: () {
                    _resetPlayers(resetVictories: false);
                  },
                  jogo: (){
                    _resetPlayers(resetVictories: true);
                  });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }

  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showEditablePlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),
      ],
    );
  }

  Widget _showPlayerName(String name) {
    return Text(
      name.toUpperCase(),
      style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          color: Colors.black),
    );
  }

  Widget _showEditablePlayerName(Player player){
    return GestureDetector(
      onTap: (){
        showDialog(context: context,
        builder: (context){
          return AlertDialog(title: Text("Editar nome do jogador"),
            content: TextField(controller: _name,
            decoration: InputDecoration(hintText: "Novo nome")),
            actions: <Widget>[FlatButton(child: Text("Cancelar"),
            onPressed: (){
              Navigator.of(context).pop();
            },
            ),
            FlatButton(child: Text("Atualizar"),
            onPressed: (){
              setState((){
                player.name = _name.text;
                Navigator.of(context).pop();
              });
              }
              )
              ]
            );
        }
        );
      },
      child: Container(
        child: _showPlayerName(player.name)
      ),
      );
    }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              if (player.score > 0){
                player.score--;
              }
            });
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.greenAccent,
          onTap: () {
            setState(() {
              if (player.score < 12){
                player.score++;
              }
            });

            if (_playerOne.score == 11 && _playerTwo.score == 11){
              genericDialog(title: "Mão de ferro",
              message: "- Ambos os jogadores chegaram aos 11 pontos!\n\n- Devem agora receber as cartas cobertas (viradas para baixo), e jogar assim. Quem vencer a mão, ganha a partida!");
            }

            if (player.score == 12) {
              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  confirm: () {
                    setState(() {
                      player.victories++;
                    });

                    _resetPlayers(resetVictories: false);
                  },
                  cancel: () {
                    setState(() {
                      player.score--;
                    });
                  });
            }
          },
        ),
      ],
    );
  }

  void _showDialog(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }

  void genericDialog({String title, String message}){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(title: Text(title),
      content: Text(message,
       textAlign: TextAlign.left),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(child: Text("OK"),
          onPressed: (){
            Navigator.of(context).pop();
            }),
        )
        ],
        );
    }
    );
  }

  void _showResetDialog(
      {String title, String message, Function partida, Function jogo, Function cancel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("PARTIDA"),
              onPressed: () {
                Navigator.of(context).pop();
                if (partida != null) partida();
              },
            ),
            FlatButton(
              child: Text("VITÓRIAS"),
              onPressed: (){
                Navigator.of(context).pop();
                if (jogo != null) jogo();
              },),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
          ],
        );
      },
    );
  }
}
