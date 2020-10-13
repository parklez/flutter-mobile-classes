import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:find_dropdown/find_dropdown.dart';

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefas'),
      // https://www.youtube.com/watch?v=2E9iZgg5TOY
      content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Título'),
                        autofocus: true,
                        validator: (value) {
                          if (value.isEmpty){
                            return "Campo obrigatório!";
                          }
                          else{
                            return null;
                          }
                        },
                        ),
                    TextFormField(
                        controller: _descriptionController,
                        // The 2 lines below allows multilines!
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(labelText: 'Descrição'),
                        validator: (value) {
                          if (value.isEmpty){
                            return "Campo obrigatório!";
                          }
                          else{
                            return null;
                          }
                        },
                        ),
                    Divider(),
                    FindDropdown(
                        items: ["1: Nenhuma", "2: Baixa", "3: Regular", "4: Alta", "5: Urgente"],
                        label: "Prioridade",
                        // This is not pretty but works...
                        onChanged: (String item){
                          if (item == "1: Nenhuma"){
                            _currentTask.priority = 1;
                          }
                          else if (item == "2: Baixa"){
                            _currentTask.priority = 2;
                          }
                          else if (item == "3: Regular"){
                            _currentTask.priority = 3;
                          }
                          else if (item == "4: Alta"){
                            _currentTask.priority = 4;
                          }
                          else
                            _currentTask.priority = 5;
                        },
                        selectedItem: "1: Nenhuma",
                        validate: (String item) {
                          if (item == null){
                            return "Campo necessário";
                          }
                          else
                            return null;
                        },
                          ),
                  ],
                ),
              ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState.validate()){
              _currentTask.title = _titleController.value.text;
              _currentTask.description = _descriptionController.text;
              Navigator.of(context).pop(_currentTask);
            }
          },
        ),
      ],
    );
  }
}
