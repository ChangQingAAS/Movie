import 'package:flutter/material.dart';
import './movie/movie_list_page.dart';
import 'package:movie/commons/app_consts.dart';

// 如果页面内只有一个动画切换效果，则实现 SingleTickerProviderStateMixin 特征即可，
// 如果存在多个动画效果，则必须实现 TickerProviderStateMixin
// 当使用的是 DefaultTabController 的时候，不需要指定任何 Mixin
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1. 使用 DefaultTabController 之后，这里不再需要定义 _controller
  // TabController _controller;
  // final List<Widget> _pageList = [
  //   const MovieListPage(movieType: 'in_theaters'),
  //   const MovieListPage(movieType: 'coming_soon'),
  //   const MovieListPage(movieType: 'top250')
  // ];
  final List<Widget> _pageList = List.generate(
      3, (index) => MovieListPage(movieType: AppConsts.pageFlags[index]));

  final List<Widget> _tabs = [
    const Tab(
      text: '正在热映',
      icon: Icon(Icons.movie_filter),
    ),
    const Tab(
      text: '即将上映',
      icon: Icon(Icons.movie_creation),
    ),
    const Tab(
      text: 'Top250',
      icon: Icon(Icons.local_movies),
    ),
  ];

  // 2. 使用 DefaultTabController 之后，这里不再需要初始化 _controller 属性
  /* @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _tabs.length);
  } */

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 14),
            ),
            centerTitle: true,
            // 右侧行为按钮
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ),
          body: TabBarView(
            // 3. 使用 DefaultTabController 之后，这里不再需要 controller 属性
            // controller: _controller,
            children: _pageList,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: Colors.grey, width: 1))),
            // height: 70,
            child: TabBar(
              labelStyle: const TextStyle(height: 0, fontSize: 12),
              // 4. 使用 DefaultTabController 之后，这里不再需要 controller 属性
              // controller: _controller,
              tabs: _tabs,
              indicatorColor: Colors.red,
            ),
          ),
          drawer: Drawer(
            child: ListView(
              // 消除顶部的灰色条区域
              padding: const EdgeInsets.all(0),
              children: const <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('ChangQingAAS'),
                  accountEmail: Text('qingchang102@gmail.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/74063075?v=4'),
                  ),
//              美化当前控件
                  decoration: BoxDecoration(
                    // 背景图片
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://static.fotor.com.cn/assets/projects/pages/0cb64de0-ac2d-11e8-9361-c9ab091bf1d0_54d99a89-f0f6-4eba-a8c0-069d0139d073_thumb.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('用户反馈'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('系统设置'),
                ),
                ListTile(
                  leading: Icon(Icons.send),
                  title: Text('我要发布'),
                ),
                Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                ListTile(
                  title: Text('注销'),
                  trailing: Icon(Icons.logout),
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: _incrementCounter,
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
