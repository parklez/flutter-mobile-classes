import 'package:http/http.dart' as http;
import 'package:search_cep/models/result_cep.dart';

bool isResponseOK(String string){
  String erro = '''{
  "erro": true
}''';
  if (string == erro){
    return false;
  }
  else{
    return true;
  }
}

class ViaCepService {
  static Future<ResultCep> fetchCep({String cep}) async {
    try {
      final response = await http.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200 && isResponseOK(response.body)) {
        return ResultCep.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Sem conexão com a internet!");
      return null;
    }
  }
}
