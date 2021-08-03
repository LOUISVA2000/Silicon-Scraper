import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silicon_scraper/theme/colors.dart';
import 'package:silicon_scraper/views/search_view.dart';
import 'package:silicon_scraper/views/watch_list_view.dart';

import 'explore_view.dart';


class MainNavigator extends StatefulWidget {
  MainNavigator({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int pageIndex=2;
  List<Widget> pageList=<Widget>[
    SearchPage(),
    WatchList(),
    Explore(),
  ];
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of views.widgets.
    return Scaffold(

      body: pageList[pageIndex],
      bottomNavigationBar: BottomNavigationBar(

        showSelectedLabels: true,
        showUnselectedLabels: false,

        currentIndex: pageIndex,
        onTap: (value){
          if(value == 0){
            showSearch(context: context, delegate: ProductSearch());
          }
          setState(() {
            pageIndex=value;
          });
        },
        backgroundColor: Colors.grey[800],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark,color: myOrange,),label: "Watch List"),
          BottomNavigationBarItem(icon: Icon(Icons.explore,color: Colors.green[600],),label: "explore"),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
