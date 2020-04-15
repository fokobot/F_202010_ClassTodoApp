import 'package:f_202010_todo_class/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:f_202010_todo_class/pages/dropdown.dart';

class HomePageTodo extends StatefulWidget {
  @override
  _HomePageTodoState createState() => _HomePageTodoState();
}

class _HomePageTodoState extends State<HomePageTodo> {
  List<Todo> todos = new List<Todo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: _list(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _addTodo, tooltip: 'Add task', child: new Icon(Icons.add)),
    );
  }

  Widget _list() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, posicion) {
        var element = todos[posicion];
        return _item(element, posicion);
      },
    );
  }

  Widget _item(Todo element, int posicion) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            todos.removeAt(posicion);
          });
        },
        child: Card(
          color: element.completed == 1 ? Colors.blueGrey : Colors.yellow[200],
          child: InkWell(
            onTap: () {
              _onTap(context, element, posicion);
            },
            child: Container(
              child: ListTile(
                leading: element.type,
                title: Text(element.title),
                subtitle: Text(element.body),
              ),
            ),
          ),
        ),
        background: Container(
            color: Colors.redAccent,
            child: Center(
                child: Text(
              'Deleting',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white),
            ))));
  }

  void _addTodo() async {
    final todo = await showDialog<Todo>(
        context: context,
        builder: (BuildContext context) {
          return NewTodoDialog();
        });

    if (todo != null) {
      setState(() {
        this.todos.add(todo);
      });
    }
  }

  void _onTap(BuildContext context, Todo location, int posicion) {
    setState(() {
      if (this.todos[posicion].completed == 0) {
        this.todos[posicion].completed = 1;
      }
    });
  }
}

class NewTodoDialog extends StatefulWidget {
  @override
  _NewTodoDialogState createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<NewTodoDialog> {
  final controllerTitle = new TextEditingController();
  final controllerBody = new TextEditingController();
  String _dropSelected = "DEFAULT";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[200],
      title: Text(
        'New todo',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
      ),
      content: Container(
        height: 200.0,
        width: 400.0,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: controllerTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Body',
              ),
              controller: controllerBody,
            ),
          ),
          TodoTypeDropdown(
              selected: _dropSelected,
              onChangedValue: (value) => setState(() {
                    _dropSelected = value;
                  }))
        ]),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20.0))),
        FlatButton(
            onPressed: () {
              Icon icon;
              print(_dropSelected);
              switch (_dropSelected) {
                case 'DEFAULT':
                  icon = Icon(Icons.check);
                  break;
                case 'CALL':
                  icon = Icon(Icons.call);
                  break;
                case 'HOME_WORK':
                  icon = Icon(Icons.contacts);
                  break;
                default:
                  icon = Icon(Icons.dialpad);
                  break;
              }
              final todo = new Todo(
                  title: controllerTitle.value.text,
                  body: controllerBody.value.text,
                  completed: 0,
                  type: icon);
              controllerBody.clear();
              controllerBody.clear();
              Navigator.of(context).pop(todo);
            },
            child: Text('Add',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20.0)))
      ],
    );
  }
}
