import 'package:flutter/material.dart';

class Todo {
  int id;
  String title;
  String body;
  int completed;
  Icon type;
  
  Todo({this.title, this.body, this.completed, this.type});
}
