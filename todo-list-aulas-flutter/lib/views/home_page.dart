import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_list/helpers/task_helper.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/views/task_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _taskList = [];
  TaskHelper _helper = TaskHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _taskList = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Lista de Tarefas'),
      actions: <Widget>[
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 4.0,
          percent: getPercentage(),
          center: Text("${(getPercentage()*100).toStringAsFixed(1)}"),
          progressColor: Colors.green,
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addNewTask),
      body: _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    if (_taskList.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem tarefas!"),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (_, int index) => Divider(height: 5),
        itemBuilder: _buildTaskItemSlidable,
        itemCount: _taskList.length,
      );
    }
  }

  Widget _buildTaskItem(BuildContext context, int index) {
    final task = _taskList[index];
    return Container(
      color: getPriorityColor(task.priority),
      child: CheckboxListTile(
        value: task.isDone,
        title: Text(task.title),
        subtitle: Text(task.description),
        onChanged: (bool isChecked) {
          setState(() {
            task.isDone = isChecked;
          });
          _helper.update(task);
        },
      ),
    );
  }

  Widget _buildTaskItemSlidable(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildTaskItem(context, index),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            _addNewTask(editedTask: _taskList[index], index: index);
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteTask(deletedTask: _taskList[index], index: index);
          },
        ),
      ],
    );
  }

  Future _addNewTask({Task editedTask, int index}) async {
    final task = await showDialog<Task>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TaskDialog(task: editedTask);
      },
    );

    if (task != null) {
      setState(() {
        if (index == null) {
          _taskList.add(task);
          _helper.save(task);
        } else {
          _taskList[index] = task;
          _helper.update(task);
        }
      });
    }
  }

  void _deleteTask({Task deletedTask, int index}) {
    setState(() {
      _taskList.removeAt(index);
    });

    _helper.delete(deletedTask.id);

    Flushbar(
      title: "Exclusão de tarefas",
      message: "Tarefa \"${deletedTask.title}\" removida.",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          "Desfazer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _taskList.insert(index, deletedTask);
            _helper.update(deletedTask);
          });
        },
      ),
    )..show(context);
  }

  Color getPriorityColor(int number){
    if (number == 1){
      return Colors.white;
    }
    else if (number == 2){
      return Colors.yellow[100];
    }
    else if (number == 3){
      return Colors.orange[100];
    }
    else if (number == 4){
      return Colors.pink[100];
    }
    else{
      return Colors.red[300];
    }
  }

  double getPercentage(){
    int total_jobs = _taskList.length;
    double done_jobs = 0;

    _taskList.forEach((job){
      if (job.isDone){
        done_jobs += 1;
      }
    });
    return (done_jobs/total_jobs);
  }
}
