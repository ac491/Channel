import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'profileRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  String fullname ;

  @override
  void initState() {
    setData();
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      fullname = sharedPreferences.getString("fullname") ?? "Error";
    });
  }

  bool isPressed = false;

  _pressed() {
    var newVal = true;
    if(isPressed) {
      newVal = false;
    } else {
      newVal = true;
    }

    setState(() {
      isPressed = newVal;
    });

  }

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Home");

  _searchUI() {
    setState(() {
      if (actionIcon.icon == Icons.search) {
        actionIcon = new Icon(Icons.close);
        appBarTitle = new TextField(
          style: new TextStyle(
            color: Colors.white,

          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)
          ),
        );
      }
      else {
        actionIcon = new Icon(Icons.search);
        appBarTitle = new Text("Home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: actionIcon, onPressed:() => _searchUI(),),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(Icons.notifications_none, color: Colors.grey,),
          ),
        ],
      ),

      body: ListView.builder(
        itemBuilder: (context, position) {

          Blog blog = Blogs.getArticle(position);
          Icon bookmarkIcon = new Icon(Icons.bookmark_border);

          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0,0.5,0.0,0.5),
            child: Card(
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyDisplayBlog(blog: blog)
                      )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(blog.category, style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500, fontSize: 16.0),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Text(blog.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),), flex: 3,),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Image.asset("assets/" + blog.image, fit: BoxFit.cover,)
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(blog.author, style: TextStyle(fontSize: 18.0),),
                              Text(blog.date + " . " + blog.readTime, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                            ],
                          ),
                          IconButton(
                              icon: new Icon(isPressed ? Icons.bookmark: Icons.bookmark_border),
                              onPressed: () => _pressed(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )

            ),
          );
        },
        itemCount: Blogs.articleCount,
      ),

      drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0,64.0,32.0,16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.account_circle, size: 90.0,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fullname, style: TextStyle(fontSize: 20.0),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(child: Text("See profile", style: TextStyle(color: Colors.black45),),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileRoute()
                              )
                          );
                        },
                        )
                        )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0,16.0,40.0,40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Home", style: TextStyle(fontSize: 18.0),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Audio", style: TextStyle(fontSize: 18.0),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Bookmarks", style: TextStyle(fontSize: 18.0),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Interests", style: TextStyle(fontSize: 18.0),),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(child: Text("Validate articles", style: TextStyle(fontSize: 18.0, color: Colors.teal),),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ValidateBlog()
                            ));
                          },),
                        ),
                        Divider(),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(child: Text("New Story", style: TextStyle(fontSize: 18.0),),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => upload()
                                )
                            );
                          },
                        )
                    ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Stats", style: TextStyle(fontSize: 18.0),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Drafts", style: TextStyle(fontSize: 18.0),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: new Text("Profile"),
        backgroundColor: Colors.black,
      ),

      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0,64.0,32.0,16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align( alignment: Alignment.topCenter,
                  child: Icon(Icons.account_circle, size: 90.0, ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Arko Chatterjee", style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,),
                      )
                  ),
                  Align(
                    alignment: Alignment.center,
                      child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Developer", style: TextStyle(color: Colors.black45), textAlign: TextAlign.center,),
                  )
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0,16.0,40.0,40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Reputation: 1600", style: TextStyle(fontSize: 18.0, color: Colors.teal),),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Interests: ML, Quantum Computing, AI", style: TextStyle(fontSize: 18.0),),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Stats", style: TextStyle(fontSize: 18.0),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Drafts", style: TextStyle(fontSize: 18.0),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )

    );
  }
}

class upload extends StatefulWidget {
  @override
  UploadBlog createState() => UploadBlog();
}

class UploadBlog extends State<upload> {

  bool apiCall = false;

  TextEditingController titleEditor = new TextEditingController();
  TextEditingController contentEditor = new TextEditingController();


  void progressIndicator(bool status) {
    // If it was calling the api and now it's false
    // that means the request has completed , and so , close the dialog
    if (apiCall == true && status == false)
      Navigator.pop(context);
    setState(() {
      apiCall = status;
    });
    showIndicator();
  }

  void showIndicator() {
    if (apiCall) {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Dialog(
          child: Container(
              height: 100.0,
              child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new CircularProgressIndicator(),
                    new Text("Loading"),
                  ],
                ),
              )),
        ),
      );
    }
  }


  _makeRequest(String title, String content) async {
    log('title : $title');
    String url = 'http://10.6.1.15:6000/blogs/upload';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> jsonText = {'title': title, 'content': content};
    progressIndicator(true);
    Response response = await post(url, headers: headers, body: json.encode(jsonText));
    progressIndicator(false);
    int statusCode = response.statusCode;
    if(statusCode == 200) {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text('Upload'),
            content: Text('Blog successfully uploaded'),
            actions: [
              new FlatButton(
                  child: const Text("Ok"),
                  onPressed: () => Navigator.pop(context)
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Form(
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(32.0),
          child: new Column(
            children: <Widget>[
          Align(
          alignment: Alignment.topLeft,
              child:Padding(
                padding: const EdgeInsets.fromLTRB(10.0,40.0,10.0,0.0),
                child: Text("Title", style: TextStyle(fontSize: 25, ),),)),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,40.0),
                  child: new SizedBox(
                height: 80.0,
                child: TextFormField(
                  controller: titleEditor,
                  //decoration: InputDecoration(labelText: "Title", labelStyle: TextStyle(fontSize: 25, )),
                  validator: (value) {
                    return value.isNotEmpty ? null : "Empty Title";
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,40.0),
            child:
              new SizedBox(
                height: 90.0,
                child: TextField(
                  controller: contentEditor,
                  keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                      labelText: "Write your story",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                )
              ) ),
              new RaisedButton(
                color: Colors.blue,
                onPressed: () => _makeRequest(titleEditor.text, contentEditor.text) ,
                child: Text("Upload"),
              ),
            ],
          ),
        )
        )
        )
    );
  }

}

class ValidateBlog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ValidateBlogState();
  }

}

class ValidateBlogState extends State<ValidateBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validate'),
        backgroundColor: Colors.black,
      ),

      body: ListView.builder(
        itemBuilder: (context, position) {

          Blog blog = Blogs.getArticle(position);
          Icon bookmarkIcon = new Icon(Icons.bookmark_border);

          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0,0.5,0.0,0.5),
            child: Card(
                child: new InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyDisplayBlogValidation(blog: blog)
                        )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(blog.category, style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500, fontSize: 16.0),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(child: Text(blog.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),), flex: 3,),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(blog.author, style: TextStyle(fontSize: 18.0),),
                                Text('Voting stops in 24 hours', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )

            ),
          );
        },
        itemCount: Blogs.articleCount,
      ),
    );
  }

}


class MyDisplayBlog extends StatefulWidget {
  Blog blog;
  MyDisplayBlog({Key key, this.blog}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DisplayBlog();
  }
}


class DisplayBlog extends State<MyDisplayBlog> {
  List<String> comments = [];
  final TextEditingController eCtrl = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.blog.category),
        backgroundColor: Colors.black,
      ),

      body: new SingleChildScrollView(
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(

                          child: Image.asset("assets/" + widget.blog.image, fit: BoxFit.fill,)
                      ),
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(widget.blog.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),), flex: 3,),
                  ],
                ),
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.blog.author, style: TextStyle(fontSize: 18.0),),
                          Text(widget.blog.date + " . " + widget.blog.readTime, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(widget.blog.content, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),), flex: 3,),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child: Text('Comments',
                style: new TextStyle(fontSize: 25.0),)),

              Padding(
              padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child: TextFormField(
                    decoration: new InputDecoration(
                    labelText: "Write your comments",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Comments cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                onFieldSubmitted: (text) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
                      comments.add(text);
                      eCtrl.clear();
                      setState(() {});
                },
                ),
              ),
              /*Expanded(
                child: SizedBox(
                  height: 200,
                child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                        return new Text(comments[Index]);
                    }
                ),
              )
              )*/
          ],
        ),
      ),
    );
  }
}

class MyDisplayBlogValidation extends StatefulWidget {
  Blog blog;
  MyDisplayBlogValidation({Key key, this.blog}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DisplayBlogValidation();
  }
}


class DisplayBlogValidation extends State<MyDisplayBlogValidation> {

  bool apiCall = false;

  void progressIndicator(bool status) {
    // If it was calling the api and now it's false
    // that means the request has completed , and so , close the dialog
    if (apiCall == true && status == false)
      Navigator.pop(context);
    setState(() {
      apiCall = status;
    });
    showIndicator();
  }

  void showIndicator() {
    if (apiCall) {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Dialog(
          child: Container(
              height: 100.0,
              child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new CircularProgressIndicator(),
                    new Text("Loading"),
                  ],
                ),
              )),
        ),
      );
    }
  }

  _voteValid(String title, String type) async {
    log('title : $title');
    String url = 'http://10.6.1.15:6000/blogs/vote/' + type;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> jsonText = {'title': title};
    progressIndicator(true);
    Response response = await post(url, headers: headers, body: json.encode(jsonText));
    progressIndicator(false);
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: Text('Vote'),
          content: Text('Voted successfully'),
          actions: [
            new FlatButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context)
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.blog.category),
        backgroundColor: Colors.black,
      ),

      body: new SingleChildScrollView(
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(

                      child: Image.asset("assets/" + widget.blog.image, fit: BoxFit.fill,)
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: Text(widget.blog.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),), flex: 3,),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.blog.author, style: TextStyle(fontSize: 18.0),),
                        Text('Voting stops in 24 hours', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: Text(widget.blog.content, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),), flex: 3,),

                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child:  Align(
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: 0.5,
                    center: new Text("50%"),
                    progressColor: Colors.green,
                  ),
                )
            ),
            Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(80.0,12.0,10.0,12.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:  RaisedButton(
                    child: new Text("Valid"),
                    color:  Colors.blueAccent[600],
                    onPressed: () => _voteValid(widget.blog.title, 'valid'),
                  ),)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
                  child: RaisedButton(
                    child: new Text("Invalid"),
                    color:  Colors.blueAccent[600],
                    onPressed: () => _voteValid(widget.blog.title, 'invalid'),
                  ),
                ),
              ],)
          ],
        ),
      ),
    );
  }
}

const BASE_URL = 'http://10.6.1.15:6000';

class APIValidate {
  static Future getUsers() {
    var url = BASE_URL + "/blogs";
    return get(url);
  }
}

class ValidBlog {
  String title;
  String author;
  String content;
  int invalid;
  int valid;
  int total_votes;

  ValidBlog(this.title, this.author, this.content, this.invalid, this.valid,
      this.total_votes);

  ValidBlog.fromJson(Map json) :
      title = json['title'],
      author = json['author'],
      content = json['content'],
      valid = json['valid'],
      invalid = json['invalid'],
      total_votes = json['total_votes'];





}

class Blog {
  String category;
  String title;
  String author;
  String date;
  String image;
  String readTime;
  String content;

  Blog(this.category, this.title, this.author, this.date, this.image, this.readTime, this.content);

}

class Blogs {

  static var articleCount = 4;

  static var categoryTitles = [
    "SPACE",
    "FROM YOUR NETWORK",
    "BASED ON YOUR READING HISTORY",
    "DATA SCIENCE"
  ];
  static var titles = [
    "Sorry, Methane and 'Organics' On Mars Are Not Evidence For Life",
    "A crash course on Serverless APIs with Express and MongoDB",
    "What happened Gmail?",
    "A year as a Data Scientist right after college: An honest review"
  ];
  /*static var titles = [
    "The new blog",
    "A crash course on Serverless APIs with Express and MongoDB",
    "What happened Gmail?",
    "A year as a Data Scientist right after college: An honest review"
  ];*/
  static var authorNames = [
    "Arko Chatterjee",
    "Adnan Rahic",
    "Avi Ashkenazi",
    "Abhishek Parkbhakar"
  ];
  static var date = ["28 Jun", "16 Dec", "27 Apr", "14 Jun"];
  static var readTimes = [
    "7 min read",
    "14 min read",
    "8 min read",
    "8 min read"
  ];
  static var imageAssetName = [
    "mars.jpeg",
    "cars.jpeg",
    "gmail.jpeg",
    "umbrella.jpeg"
  ];

  static var content = [
    "Lorem ipsum dolor sit amet, eam exerci voluptatum efficiantur ut, mel platonem omittantur mediocritatem id. Mazim appareat te ius, vim ea accusam imperdiet, dolor expetendis vix id. Vix case nominati ea. Causae fuisset ea per. Qui ad nullam regione, choro accumsan cu vim.",
    "Lorem ipsum dolor sit amet, eam exerci voluptatum efficiantur ut, mel platonem omittantur mediocritatem id. Mazim appareat te ius, vim ea accusam imperdiet, dolor expetendis vix id. Vix case nominati ea. Causae fuisset ea per. Qui ad nullam regione, choro accumsan cu vim.",
    "Lorem ipsum dolor sit amet, eam exerci voluptatum efficiantur ut, mel platonem omittantur mediocritatem id. Mazim appareat te ius, vim ea accusam imperdiet, dolor expetendis vix id. Vix case nominati ea. Causae fuisset ea per. Qui ad nullam regione, choro accumsan cu vim.",
    "Lorem ipsum dolor sit amet, eam exerci voluptatum efficiantur ut, mel platonem omittantur mediocritatem id. Mazim appareat te ius, vim ea accusam imperdiet, dolor expetendis vix id. Vix case nominati ea. Causae fuisset ea per. Qui ad nullam regione, choro accumsan cu vim.",
  ];

  static getArticle(int position) {
    return Blog(
        categoryTitles[position], titles[position], authorNames[position],
        date[position], imageAssetName[position], readTimes[position], content[position]);
  }
}
