import 'package:movie/api/movie_api.dart';
import 'package:flutter/material.dart';
import './movie_detail_page.dart';

MovieApi movieApi = MovieApi();

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key, required this.movieType}) : super(key: key);

  final String movieType;

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

// 有状态控件，必须结合一个状态管理类，来进行实现
class _MovieListPageState extends State<MovieListPage>
    with AutomaticKeepAliveClientMixin {
  // 当前的页数
  int _page = 1;

  // 每页显示的数据数量
  final int _pageSize = 10;

  // 电影列表
  var movieList = [];

  // 总数据条数，实现分页效果
  var _total = 0;

  // 是否加载完毕了
  bool _isOver = false;

  // 是否正在加载数据
  bool _isLoading = true;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;

//  控件被创建的时候,会调用initState方法
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了第$_page页的底部');
        // 是否正在加载中或所有数据加载完毕了
        if (_isLoading || _isOver) return;
        // 判断是否加载完毕了所有的数据
        if (_page * _pageSize >= _total) {
          setState(() {
            _isOver = true;
          });
          return;
        }
        // 页码值自增 +1
        setState(() {
          _page++;
        });
        // 获取下一页数据
        getMovieList();
      }
    });
    getMovieList();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Text("这是电影列表界面 --- ${widget.movieType} ---- ${movieList.length}");
    return ListView.builder(
        itemCount: movieList.length,
        itemBuilder: (BuildContext context, int index) {
          var movieItem = movieList[index];
          return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext ctx) {
                  return MovieDetailPage(
                      id: movieItem['id'],
                      title: movieItem['title'],
                      img: movieItem['images']['small']);
                }));
              },
              child: Column(
                children: <Widget>[
                  const Divider(
                    height: 1,
                  ),
                  Container(
                      height: 200,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                            color: Colors.black12,
                          ))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Image.network(movieItem['images']['small'],
                                width: 130, height: 180, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 130,
                                height: 180,
                                color: Colors.red,
                                alignment: Alignment.center,
                                child: const Text(
                                  'IMAGE ERROR',
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            }),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                // 平分
                                children: <Widget>[
                                  Text(
                                    "电影名称: ${movieItem['title']}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text("上映时间: ${movieItem['year']}年",
                                      style: const TextStyle(fontSize: 12)),
                                  Text("电影类型: ${movieItem['genres'].join(',')}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "豆瓣评分: ${movieItem['rating']['average']}分",
                                      style: const TextStyle(fontSize: 12)),
                                  Row(
                                    children: <Widget>[
                                      const Text('主演：',
                                          style: TextStyle(fontSize: 12)),
                                      Row(
                                        children: List.generate(
                                            movieItem['casts'].length,
                                            (int index) => Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        movieItem['casts']
                                                                        [index][
                                                                    'avatars'] ==
                                                                null
                                                            ? 'https://img3.doubanio.com/f/movie/8dd0c794499fe925ae2ae89ee30cd225750457b4/pics/movie/celebrity-default-medium.png'
                                                            : movieItem['casts']
                                                                        [index]
                                                                    ['avatars']
                                                                ['small']),
                                                  ),
                                                )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ])),
                ],
              ));
        },
        controller: _scrollController);
  }

  // 获取电影列表数据
  getMovieList() async {
    print("加载第 $_page 页数据");
    setState(() {
      _isLoading = true;
    });

    var result =
        await movieApi.getMovieList(widget.movieType, _page, _pageSize);
    // print(result);

    // 只要为私有数据赋值,都要调用setState方法，否则，页面不会更新
    setState(() {
      movieList.addAll(result['subjects']);
      _total = result['total'];
      _isLoading = false;
    });
  }
}
