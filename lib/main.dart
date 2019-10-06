import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Icon actionIcon = new Icon(Icons.search);
    Widget appBarTitle = new Text("Home");
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(Icons.notifications_none, color: Colors.grey,),
          ),
          IconButton(icon: actionIcon, onPressed:(){
              setState(() {
                if (actionIcon.icon == Icons.search){
                  actionIcon = new Icon(Icons.close);
                  appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  actionIcon = new Icon(Icons.search);
                  appBarTitle = new Text("Home");
                }


              });
            } ,),
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
                          builder: (context) => DisplayBlog(blog: blog)
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
                            icon: bookmarkIcon, onPressed: () {
                              setState(() {
                                bookmarkIcon = new Icon(Icons.bookmark);
                              });
                          },
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
                        child: Text("Arko Chatterjee", style: TextStyle(fontSize: 20.0),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(child: Text("See profile", style: TextStyle(color: Colors.black45),),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()
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
                          child: Text("Become a member", style: TextStyle(fontSize: 18.0, color: Colors.teal),),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("New Story", style: TextStyle(fontSize: 18.0),),
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

class DisplayBlog extends StatelessWidget {
  Blog blog;

  DisplayBlog({Key key, this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(blog.category),
        backgroundColor: Colors.black,
      ),

      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(

                        child: Image.asset("assets/" + blog.image, fit: BoxFit.fill,)
                    ),
                  ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,12.0,10.0,12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: Text(blog.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),), flex: 3,),
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
                        Text(blog.author, style: TextStyle(fontSize: 18.0),),
                        Text(blog.date + " . " + blog.readTime, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ],
                )
            ),
        ],
      ),
    );
  }
}

class Blog {
  String category;
  String title;
  String author;
  String date;
  String image;
  String readTime;

  Blog(this.category, this.title, this.author, this.date, this.image, this.readTime);

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
  static var authorNames = [
    "Ethan Siegal",
    "Adnan Rahic",
    "Avi Ashkenazi",
    "Abhishek Parkbhakar"
  ];
  static var date = ["15 Jun", "15 hours ago", "27 Apr", "14 Jun"];
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

  static getArticle(int position) {
    return Blog(
        categoryTitles[position], titles[position], authorNames[position],
        date[position], imageAssetName[position], readTimes[position]);
  }
}
