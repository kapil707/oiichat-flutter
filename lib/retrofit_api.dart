import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oiichat/models/FriendPageModel.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/models/LoginModel.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_api.g.dart';

//flutter pub run build_runner build
@RestApi(
    //baseUrl: "https://www.drdistributors.co.in/drd-live/flutter_api/Api01/")
    baseUrl: "http://160.30.100.216:3000/api/")
abstract class MyApiService {
  factory MyApiService(Dio dio, {String baseUrl}) = _MyApiService;

  @POST("user/login")
  @FormUrlEncoded()
  Future<LoginModel> login_api(
      @Field("api_key") String apiKey,
      @Field("email") String userName,
      @Field("password") String userPassword,
      @Field("firebase_token") String firebaseToken);

  @POST("user/alluser")
  @FormUrlEncoded()
  Future<HomePageModel> home_page_api(@Field("api_key") String apiKey);

  @POST("user/alluser")
  @FormUrlEncoded()
  Future<FriendPageModel> friend_page_api(@Field("api_key") String apiKey);

  @POST("user/profile_upload")
  @MultiPart()
  Future<String> uploadImage(
    @Part(name: "image") File image, // Add image file
  );

  /*@POST("/my_notification_api")
  @FormUrlEncoded()
  Future<NotificationModel> my_notification_api(
      @Field("api_key") String apiKey,
      @Field("user_type") String userType,
      @Field("user_altercode") String userAltercode,
      @Field("user_password") String userPassword,
      @Field("user_nrx") String userNrx,
      @Field("chemist_id") String chemistId,
      @Field("get_record") String getRecord);*/
}
