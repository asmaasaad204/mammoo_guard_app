import 'package:facebook/Chat/chat_navigator.dart';
import 'package:facebook/Chat/message.dart';
import 'package:facebook/database_utils.dart';
import 'package:flutter/material.dart';
import '../models/my_user.dart';

class ChatScreenViewModel extends ChangeNotifier{
  late ChatNavigator navigator;
  late MyUser currentUser ;
  void SendMessage(String content) async{
    Message message = Message(
        content: content,
        senderId: currentUser.id,
        senderName: currentUser.name,
        dateTime: DateTime.now().millisecondsSinceEpoch,
    );
    try{
      var res = await DatabaseUtils.insertMessage(message);
      /// clear message
      navigator.clearMessage();
    }
    catch(error){
      navigator.showMessage(error.toString());
    }
  }
}