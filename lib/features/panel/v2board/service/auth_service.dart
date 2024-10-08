// Archivo: lib/features/login/service/auth_service.dart
import 'package:hiddify/features/panel/v2board/models/invite_code_model.dart';
import 'package:hiddify/features/panel/v2board/models/plan_model.dart';
import 'package:hiddify/features/panel/v2board/models/user_info_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const _baseUrl = "https://kssw.181889.xyz";
  static const _inviteLinkBase = "$_baseUrl/#/register?code=";

  // Método para obtener el enlace completo del código de invitación
  static String getInviteLink(String code) {
    return '$_inviteLinkBase$code';
  }

  // Método POST unificado
  Future<Map<String, dynamic>> _postRequest(
      String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse("$_baseUrl$endpoint");
    final response = await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Solicitud a $endpoint fallida: ${response.statusCode}");
    }
  }

  // Método GET unificado
  Future<Map<String, dynamic>> _getRequest(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse("$_baseUrl$endpoint");
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Solicitud a $endpoint fallida: ${response.statusCode}");
    }
  }

  // Método para transferir comisión al saldo
  Future<bool> transferCommission(
      String accessToken, int transferAmount) async {
    final response = await _postRequest(
      '/api/v1/user/transfer',
      {'transfer_amount': transferAmount},
      headers: {'Authorization': accessToken}, // Requiere el token de autenticación del usuario
    );

    return true;
  }

  // Método para generar código de invitación
  Future<bool> generateInviteCode(String accessToken) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/invite/save");
    final response = await http.get(
      url,
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      return true; // Generación exitosa
    } else {
      throw Exception(
          "Solicitud para generar código de invitación fallida: ${response.statusCode}");
    }
  }

  // Obtener datos de los códigos de invitación
  Future<List<InviteCode>> fetchInviteCodes(String accessToken) async {
    final result = await _getRequest("/api/v1/user/invite/fetch", headers: {
      'Authorization': accessToken,
    });

    final codes = result["data"]["codes"] as List;
    return codes.map((json) => InviteCode.fromJson(json)).toList();
  }

  // Solicitud de inicio de sesión
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _postRequest(
      "/api/v1/passport/auth/login",
      {"email": email, "password": password},
    );
  }

  // Solicitud de registro
  Future<Map<String, dynamic>> register(String email, String password,
      String inviteCode, String emailCode) async {
    return await _postRequest(
      "/api/v1/passport/auth/register",
      {
        "email": email,
        "password": password,
        "invite_code": inviteCode,
        "email_code": emailCode,
      },
    );
  }

  // Solicitud para enviar código de verificación
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    final url = Uri.parse("$_baseUrl/api/v1/passport/comm/sendEmailVerify");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          "No se pudo enviar el código de verificación: ${response.statusCode}");
    }
  }

  // Solicitud para restablecer la contraseña
  Future<Map<String, dynamic>> resetPassword(
      String email, String password, String emailCode) async {
    return await _postRequest(
      "/api/v1/passport/auth/forget",
      {
        "email": email,
        "password": password,
        "email_code": emailCode,
      },
    );
  }

  // Solicitud para obtener el enlace de suscripción
  Future<String?> getSubscriptionLink(String accessToken) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/getSubscribe");
    final response = await http.get(
      url,
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"]["subscribe_url"];
    } else {
      throw Exception(
          "No se pudo obtener el enlace de suscripción: ${response.statusCode}");
    }
  }

  // Solicitud para obtener los datos del plan
  Future<List<Plan>> fetchPlanData(String accessToken) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/plan/fetch");
    final response = await http.get(
      url,
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data["data"] as List)
          .map((json) => Plan.fromJson(json))
          .toList();
    } else {
      throw Exception("No se pudo obtener los datos del plan: ${response}");
    }
  }

  // Método para validar token
  Future<bool> validateToken(String token) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/getSubscribe");
    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      // Manejar el caso de expiración del token
      return false;
    } else {
      // Manejar otros errores
      return false;
    }
  }

  // Obtener información del usuario
  Future<UserInfo?> fetchUserInfo(String accessToken) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/info");
    final result = await http.get(
      url,
      headers: {'Authorization': accessToken},
    );

    if (result.statusCode == 200) {
      final data = json.decode(result.body);
      return UserInfo.fromJson(data["data"]);
    } else {
      final errorBody = result.body;
      throw Exception("No se pudo obtener la información del usuario: $errorBody");
    }
  }

  // Restablecer enlace de suscripción
  Future<String?> resetSubscriptionLink(String accessToken) async {
    final url = Uri.parse("$_baseUrl/api/v1/user/resetSecurity");
    final response = await http.get(
      url,
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"];
    } else {
      throw Exception(
          "No se pudo restablecer el enlace de suscripción: ${response.statusCode}");
    }
  }
}
