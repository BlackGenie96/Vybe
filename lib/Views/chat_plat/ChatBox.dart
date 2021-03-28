import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ChatBox extends StatefulWidget{
  @override
  ChatBoxState createState() => new ChatBoxState();
}

class ChatBoxState extends State<ChatBox>{

  SharedPreferences prefs;
  TextEditingController messageController = new TextEditingController();
  File _pickedImage;
  var ext;
  Future<List<MessageItem>> _messageList;
  int globalOrgid;

  void pickImage() async{
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder:(context)=> AlertDialog(
        title:Text('Select the image source'),
        actions: <Widget>[
          MaterialButton(
            child:Text('Camera'),
            onPressed: ()=>Navigator.pop(context,ImageSource.camera)
          ),
          MaterialButton(
            child: Text('Gallery'),
            onPressed:()=> Navigator.pop(context,ImageSource.gallery)
          ),
        ]
      ),
    );

    if(imageSource != null){
      final file = await ImagePicker.pickImage(source: imageSource);
      if(file != null) {
        setState(() {
          _pickedImage = file;
        });
        ext = path.extension(_pickedImage.path);
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context)=> ConfirmImage(pickedImage: _pickedImage)
            ));
        //sendMessage();
        //print("Sending message");
      }
    }
  }

  @override
  void initState(){
    super.initState();
    _messageList = getMessagesForOrg();
    _messageList.then((List<MessageItem> item){
      for(var i=0; i<item.length; i++){
        print("${item[i]}");
      }
    });
    getOrgId();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context)=> Scaffold(
          appBar: AppBar(
            title: Text('Payment Agent',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child:Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize : MainAxisSize.max,
                  children: <Widget>[
                    FutureBuilder(
                        future : _messageList,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<MessageItem> data = snapshot.data;
                            return _buildMessagesBody(data);
                          }else if(snapshot.hasError){
                            return Center(child:Text('No messages.'));
                          }
                          return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
                        }
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: TextFormField(
                              controller: messageController,
                              style:TextStyle(
                                fontFamily: 'SF-Pro',
                                color: Colors.black,
                              ),
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                labelText:'Write a message...',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'SF-Pro',
                                  fontStyle: FontStyle.italic,
                                ),
                                border : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(color: Colors.black,width:1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(color:Colors.black, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: IconButton(
                                icon: Icon(Icons.attach_file),
                                color: Colors.black,
                                onPressed: (){
                                  print("Picking image");
                                  pickImage();
                                }
                            ),
                          ),
                          Container(
                            child: IconButton(
                                icon: Icon(Icons.send),
                                color: Colors.black,
                                onPressed: (){
                                  print('sending message');
                                  sendMessage();
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getOrgId() async{
    prefs = await SharedPreferences.getInstance();
    globalOrgid = prefs.getInt("orgId");
  }

  Widget _buildMessagesBody(List<MessageItem> data)=> ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index){
      MessageItem item = data[index];

      if(item.sentFrom == globalOrgid){
        return _senderTile(item);
      }else{
        return _receiverTile(item);
      }
    },shrinkWrap: true,
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    physics: NeverScrollableScrollPhysics(),
  );

  Container _senderTile(MessageItem item) => Container(
    alignment: Alignment.centerRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Color(0xffaaaaaa),
          ),
          child: Row(
            mainAxisSize:MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    item.imageUrl == "" || item.imageUrl == null ? Text('',style:TextStyle(fontStyle:FontStyle.italic,fontFamily:'SF-Pro',)) : GestureDetector(
                      onTap:(){
                        goToImageHero(item);
                      },
                      child: Hero(
                        tag: item.imageUrl,
                        child:Container(
                            child: Image.network(item.imageUrl),
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.3
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('${item.message}',textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            item.time,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'SF-Pro',
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );

  goToImageHero(item){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar:AppBar(
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color:Colors.white,
                ),
                title: Text('Image', style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
              ),
              body:SafeArea(
                child: Center(
                  child: Hero(
                    tag: item.imageUrl,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Image.network(item.imageUrl)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _receiverTile(MessageItem item) => Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(
      bottom: 12,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          margin: const EdgeInsets.only(right: 90,top:8, bottom: 7),
          decoration: BoxDecoration(
            color : Color(0xff000000),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(item.message,textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.white)),
              ),
            ],
          ),
        ),
        Text(
          item.time,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 12,
          ),
        ),
      ],
    ),
  );

  sendMessage() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('orgId');

    final url = "http://192.168.43.56/Vybe/flutter_api/messaging/send_org_approval.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data;

    if(_pickedImage != null && messageController.text.isNotEmpty){
      data = {
        "image" : base64Encode(_pickedImage.readAsBytesSync()),
        "message" : messageController.text,
        "orgId" : id,
        "ext" : ext
      };
    }else if(_pickedImage != null && messageController.text.isEmpty){
      data = {
        "image" : base64Encode(_pickedImage.readAsBytesSync()),
        "orgId" : id,
        "ext" : ext
      };
    }else if(_pickedImage == null && messageController.text.isEmpty){
      nothingToSendDialog();
      return;
    }else if(_pickedImage == null && messageController.text.isNotEmpty){
      data = {
        "message" : messageController.text,
        "orgId" : id
      };
    }

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);

    if(response.statusCode == 200){
      Map<String,dynamic> res = json.decode(response.body);
      var success = res["success"];
      var message = res["message"];

      if(success == 1){
        //MessageItem item = MessageItem.fromJson(res["messages"]);
        print(message);
        setState(() {
          _messageList = getMessagesForOrg();
          messageController.clear();
        });
      }else{
        print(message);
      }
    }else{
      throw Exception('Error from server');
    }
  }

  Future<List<MessageItem>>getMessagesForOrg() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('orgId');

    final url = "http://192.168.43.56/Vybe/flutter_api/messaging/get_org_messages.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "org_id" : id
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body : json.encode(data)
    );

    //handle response
    print(response.body);

    if(response.statusCode == 200){
      Map res = json.decode(response.body);
      ResponseItem responseItem = new ResponseItem.fromJson(res);
      if(responseItem.success == 1 && responseItem.messages.isNotEmpty){
        print(responseItem.message);

        return responseItem.messages;
      }else{
        print(responseItem.message);
      }
    }else{
      throw Exception('Error getting messages');
    }
  }

  void nothingToSendDialog() async{
    await showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text('Alert',style:TextStyle(fontWeight:FontWeight.bold,fontFamily:'Raleway',color:Colors.white),textAlign:TextAlign.center,),
        backgroundColor: Colors.red[600],
        content:Text('There is nothing to send',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontFamily:'Raleway',fontSize:22)),
        actions: <Widget>[
          MaterialButton(
            child: Text('Close'),
            color: Colors.white,
            textColor:Colors.black,
            padding:const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class ResponseItem{
  String message;
  int success;
  List<MessageItem> messages;

  ResponseItem({this.message, this.success, this.messages});

  factory ResponseItem.fromJson(Map<String, dynamic> json) => ResponseItem(
    message : json["message"],
    success : json["success"],
    messages: json["messages"] == null ? [] : List<MessageItem>.from(json["messages"].map((item) => MessageItem.fromJson(item)))
  );
}

class MessageItem{

  int id;
  int sentFrom;
  int sentTo;
  String message;
  String imageUrl;
  String time;

  MessageItem({this.id, this.sentFrom, this.sentTo, this.message, this.imageUrl, this.time});

  factory MessageItem.fromJson(Map<String,dynamic> json) => MessageItem(
    id : int.parse(json["id"].toString()),
    sentFrom : int.parse(json["sentFrom"]),
    sentTo : int.parse(json["sentTo"]),
    message: json["message"],
    imageUrl: json["imageUrl"] == null || json["imageUrl"] == "" ? "" : json["imageUrl"],
    time : json["time"]
  );
}

class ConfirmImage extends StatefulWidget{
  final File pickedImage;
  final String message;

  ConfirmImage({this.pickedImage, this.message});
  @override
  _ConfirmImageState createState() => new _ConfirmImageState(pickedImage: pickedImage, message: message);
}

class _ConfirmImageState extends State<ConfirmImage>{

  File pickedImage;
  String message;

  _ConfirmImageState({this.pickedImage, this.message});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Selected Image',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Colors.black,
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Image.file(pickedImage),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Color(0xffcd5e14),
                      textColor: Colors.white,
                      child: Text('Send',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30.0)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(height: 15.0),
                    RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Cancel',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro')),
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30.0)),
                      onPressed: () {
                        setState(() {
                          pickedImage = null;
                        });
                        Navigator.pop(context);
                      },
                    )
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}