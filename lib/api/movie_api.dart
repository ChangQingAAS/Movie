import 'package:dio/dio.dart';
import 'package:movie/commons/app_consts.dart';

Dio dio = Dio();

class MovieApi {
  //  获取电影列表
  getMovieList(String movieType, int page, int pageSize) async {
    // 偏移量=(当前页-1)*每页条数
    int offset = (page - 1) * pageSize;
    var response = await dio.get(
        '${AppConsts.movieBaseUrl}/$movieType?start=$offset&count=$pageSize');
    var result = response.data;

    return result;
  }

  //  获取电影详情
  getMovieDetail(String id) async {
    var response = await dio.get('${AppConsts.movieBaseUrl}/subject/$id');
    var result = response.data;

    return result;
  }
}
