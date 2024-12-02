import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oiichat/models/FriendPageModelApi.dart';
import 'package:oiichat/models/FriendPageModel.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/models/LoginModel.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_api.g.dart';

//flutter pub run build_runner build
@RestApi(baseUrl: "http://160.30.100.216:3000/api/")
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
  Future<FriendPageModelApi> friend_page_api(@Field("api_key") String apiKey);

  @POST("user/profile_upload")
  @MultiPart()
  Future<String> uploadImage(
    @Part(name: "profileImage") File image, // Add image file
    @Part(name: "user_id") String userId,
  );
}
