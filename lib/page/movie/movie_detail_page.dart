import 'package:movie/api/movie_api.dart';
import 'package:flutter/material.dart';

MovieApi movieApi = MovieApi();

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage(
      {Key? key, required this.id, required this.title, required this.img})
      : super(key: key);

  //  电影ID
  final String id;

  //  电影标题
  final String title;

//  电影封面
  final String img;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
//  电影详情
  var _movieInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMovieInfo();
  }

  _getMovieInfo() async {
    var result = await movieApi.getMovieDetail(widget.id);
    setState(() {
      _movieInfo = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 14)),
        centerTitle: true,
      ),
      body: _renderInfo(),
    );
  }

  Widget _renderInfo() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            // child: Image.network(_movieInfo['images']['large'], height: 350),
            child: Image.network(widget.img,
                // width: 130,
                height: 350,
                // fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
              return Container(
                // width: 130,
                height: 350,
                color: Colors.red,
                alignment: Alignment.center,
                child: const Text(
                  'IMAGE ERROR',
                  style: TextStyle(fontSize: 30),
                ),
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              // _movieInfo['summary'],
              widget.title,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          )
        ],
      );
    }
  }
}
