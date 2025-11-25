import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/model/auth_request.dart';
import 'package:rivu_v1/auth/model/auth_response.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
import 'package:rivu_v1/auth/model/user_model.dart';
import 'package:rivu_v1/models/history_model.dart';
import 'dio_provider.dart';
part 'auth_api_client.g.dart'; 
final authApiClientProvider = Provider<AuthApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiClient(dio);
});
@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;
  @POST("/login")
  @FormUrlEncoded() 
  Future<LoginResponse> login(@Body() Map<String, dynamic> request);
  @POST("/register")
  Future<UserRegisterResponse> register(@Body() UserCreateRequest request);
  @POST("/mobile/provision-device")
  Future<DeviceProvisionResponse> provisionDevice(
    @Body() DeviceProvisionRequest request,
  );
  @POST("/auth/forgot-password")
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);
  @POST("/auth/verify-otp")
  Future<void> verifyOtp(@Body() Map<String, dynamic> body);
  @PUT("/users/me")
  Future<UserModel> updateProfile(@Body() Map<String, dynamic> body);
  @PUT("/users/me/password")
  Future<void> changePassword(@Body() Map<String, dynamic> body);
  @POST("/users/me/avatar")
  @MultiPart()
  Future<UserModel> uploadAvatar(@Part() File file);
  @POST("/auth/reset-password")
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
  @DELETE("/mobile/system/{systemId}")
  Future<void> unlinkDevice(@Path("systemId") String systemId);
  @GET("/mobile/my-systems")
  Future<List<SystemModel>> getMySystems();
  @POST("/mobile/system/{systemId}/log")
  Future<void> postHistoryLog(
    @Path("systemId") String systemId,
    @Body() Map<String, dynamic> body,
  );
  @GET("/mobile/system/{systemId}/logs")
  Future<List<HistoryModel>> getHistoryLogs(@Path("systemId") String systemId);
}
