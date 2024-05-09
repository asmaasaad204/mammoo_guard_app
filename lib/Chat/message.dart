class Message {
  static const String collectionName = 'messages';
  String id;
  String content;
  String senderId;
  String senderName;
  int dateTime;

  Message({
    this.id = '',
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.dateTime,
  });

  Message.fromJson(Map<String,dynamic> json):this(
    id:  json['id'] as String ,
    content:  json['content'] as String ,
    senderId:  json['sender_id'] as String ,
    senderName:  json['sender_name'] as String ,
    dateTime:  json['dateTime'] as int ,
  );

  Map<String,dynamic> toJson(){
    return{
      'id' : id ,
      'content' : content ,
      'sender_id' : senderId ,
      'sender_name' : senderName ,
      'dateTime' : dateTime ,

    };
  }
}
