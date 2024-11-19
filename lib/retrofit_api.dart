import 'package:dio/dio.dart';
import 'package:oiichat/models/FriendPageModel.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/models/LoginModel.dart';
import 'package:oiichat/models/NotificationModel.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_api.g.dart';

//flutter pub run build_runner build
@RestApi(
    //baseUrl: "https://www.drdistributors.co.in/drd-live/flutter_api/Api01/")
    baseUrl: "http://192.168.1.7:3000/api/")
abstract class MyApiService {
  factory MyApiService(Dio dio, {String baseUrl}) = _MyApiService;

  @POST("user/login")
  @FormUrlEncoded()
  Future<LoginModel> login_api(
      @Field("api_key") String api_key,
      @Field("email") String user_name,
      @Field("password") String user_password,
      @Field("firebase_token") String firebase_token);

  @POST("user/alluser")
  @FormUrlEncoded()
  Future<HomePageModel> home_page_api(
      @Field("api_key") String api_key);

  @POST("user/alluser")
  @FormUrlEncoded()
  Future<FriendPageModel> friend_page_api(
      @Field("api_key") String api_key);

  @POST("/my_notification_api")
  @FormUrlEncoded()
  Future<NotificationModel> my_notification_api(
      @Field("api_key") String api_key,
      @Field("user_type") String user_type,
      @Field("user_altercode") String user_altercode,
      @Field("user_password") String user_password,
      @Field("user_nrx") String user_nrx,
      @Field("chemist_id") String chemist_id,
      @Field("get_record") String get_record);
}
