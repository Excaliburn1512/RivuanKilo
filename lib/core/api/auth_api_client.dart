import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/model/auth_request.dart';
import 'package:rivu_v1/auth/model/auth_response.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
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
  @DELETE("/mobile/system/{systemId}")
  Future<void> unlinkDevice(@Path("systemId") String systemId);
  @GET("/mobile/my-systems")
  Future<List<SystemModel>> getMySystems();
}
