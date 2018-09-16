import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FriendlychatApp());
}

const String _name = "Peter Birdsall";

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS         //new
          ? kIOSTheme                                              //new
          : kDefaultTheme,                                         //new
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => ChatScreenState();                    //new
}

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat"),
        elevation:
        Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0, //new
      ),
    body: new Container(                                             //modified
    child: new Column(                                           //modified
        children: <Widget>[                                         //new
          new Flexible(                                             //new
            child: new ListView.builder(                            //new
              padding: new EdgeInsets.all(8.0),                     //new
              reverse: true,                                        //new
              itemBuilder: (_, int index) => _messages[index],      //new
              itemCount: _messages.length,                          //new
            ),                                                      //new
          ),                                                        //new
          new Divider(height: 1.0),                                 //new
          new Container(                                            //new
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor),                  //new
            child: _buildTextComposer(),                       //modified
          ),                                                        //new
        ],                                                          //new
      ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? new BoxDecoration(                                     //new
          border: new Border(                                  //new
            top: new BorderSide(color: Colors.grey[200]),      //new
          ),                                                   //new
        )                                                      //new
            : null),                                                 //modified//new
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {          //new
                  setState(() {                     //new
                    _isComposing = text.length > 0; //new
                  });                               //new
                },                                  //new
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?  //modified
              new CupertinoButton(                                       //new
                child: new Text("Send"),                                 //new
                onPressed: _isComposing                                  //new
                    ? () =>  _handleSubmitted(_textController.text)      //new
                    : null,) :                                           //new
              new IconButton(                                            //modified
                icon: new Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)    //modified
                    : null,                                           //modified
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    });                                                              //new
    ChatMessage message = new ChatMessage(                         //new
      text: text,                                                  //new
      animationController: new AnimationController(                  //new
        duration: new Duration(milliseconds: 700),                   //new
        vsync: this,                                                 //new
      ),                                                             //new
    );                                                               //new
    setState(() {                                                  //new
      _messages.insert(0, message);                                //new
    });
    message.animationController.forward();                           //new
  }

  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }                                                                  //new
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});         //modified
  final String text;
  final AnimationController animationController;                   //new


  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
        sizeFactor: new CurvedAnimation(                              //new
        parent: animationController, curve: Curves.easeOut),      //new
    axisAlignment: 0.0,                                           //new
    child: new Container(                                    //modified
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}