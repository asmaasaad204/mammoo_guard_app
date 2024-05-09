import 'package:facebook/Chat/chat_navigator.dart';
import 'package:facebook/Chat/chat_screen_view_model.dart';
import 'package:facebook/taps/pages_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facebook/dialog_utils.dart';
import 'package:facebook/home/auth_provider.dart';
 
class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements ChatNavigator{
  // ChatScreenViewModel viewModel = ChatScreenViewModel();
  // String messageContent = '';
  // TextEditingController controller = TextEditingController();
  @override
  void initState(){
    super.initState();
    // viewModel.navigator = this;
  }
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    // viewModel.currentUser = provider.user! ;
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Image.asset("assets/images/chatt.png",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(PagesScreen.routeName);
              },
              child: Icon(Icons.arrow_back,color: Color(0xffF8CAE4),),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
              margin: EdgeInsets.only(bottom: 20,left: 20,right: 20,top: 120),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff8c909c).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            // controller: controller,
                            onChanged: (text){
                              // messageContent = text;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Type a message",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(12))
                                )
                            ),
                          )),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: (){
                          // viewModel.SendMessage(messageContent);
                        },
                        child: Row(
                          children: [
                            Text("Send"),
                            SizedBox(width: 10,),
                            Icon(Icons.send_outlined)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }

  @override
  void showMessage(String message) {
    DialogUtils.showMessage(context, message);
  }

  @override
  void clearMessage() {
    // controller.clear();
  }
}
