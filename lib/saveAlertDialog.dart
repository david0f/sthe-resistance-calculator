import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SaveAlertDialog extends StatelessWidget{
  bool _allowFileWrite;
  TextEditingController _fileNameController = TextEditingController();

   
   requestWritePermission() async{
    PermissionStatus pStatus = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);

    if (pStatus == PermissionStatus.authorized){
      return true;
    }
    else{
      return false;
    }
  }

  _displaySaveDialog(BuildContext context) async {
    _allowFileWrite = await requestWritePermission();
    if(_allowFileWrite){
      return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text("Save as file"),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      controller: _fileNameController,
                      decoration: new InputDecoration(
                        hasFloatingPlaceholder: true,
                        isDense: true,
                        labelText: "File name",
                        hintText: "ex: Cuptor Popescu",
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: Text("SAVE"),
                  onPressed: () {
                    writeContent(_fileNameController.text);
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ));}
            else{
              return showDialog(
                context: context,
                builder: (_) => new AlertDialog(
              title: Text("Sorry"),
              content: Text("Saving your current calculations in a text file requires storage permissions."),
              actions: <Widget>[
                new FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
              ));
            }
  }

  @override
  Widget build(BuildContext context){
    return FloatingActionButton.extended(
          onPressed: () {
              return _displaySaveDialog(context);
          },
          icon: Icon(Icons.save),
          label: Text("Save"),
        );

  }

  Future<String> get _localPath async{
    final directory = await getExternalStorageDirectory();
    return directory.path;
  } 

  Future<File> _localFile(String fileName) async{
    final path = await _localPath;
    return File('$path/$fileName.txt');
  }

  Future<File> writeContent(String fileName) async{

    fileName += "_"+DateTime.now().toString().split(' ')[0];
    debugPrint(fileName);
    final file = await _localFile(fileName);
    if(FileSystemEntity.typeSync(file.path) != FileSystemEntityType.notFound)
    
    //to do: handle in the ui if the file exists.
      debugPrint("file exists");
    else
      debugPrint("not found, creating");

    return file.writeAsString("123proba123");
  }
  }