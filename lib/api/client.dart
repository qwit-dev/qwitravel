import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:qwitravel/api/endpoints.dart';
// import 'package:qwitravel/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:uuid/uuid.dart';

class BKKClient {
  String? accessToken;
  String? refreshToken;
  String? idToken;
  String? userAgent;
  late http.Client client;

  bool _loginRefreshing = false;

  BKKClient({
    this.accessToken,
  }) : userAgent = 'settings.config.userAgent' {
    var ioclient = HttpClient();
    ioclient.badCertificateCallback = _checkCerts;
    client = http.IOClient(ioclient);
  }

  bool _checkCerts(X509Certificate cert, String host, int port) {
    // return _settings.developerMode;
    return false;
  }

  Future<dynamic> getAPI(
    String url, {
    Map<String, String>? headers,
    bool autoHeader = true,
    bool json = true,
    bool rawResponse = false,
  }) async {
    Map<String, String> headerMap;

    if (rawResponse) json = false;

    if (headers != null) {
      headerMap = headers;
    } else {
      headerMap = {};
    }

    try {
      http.Response? res;

      for (int i = 0; i < 3; i++) {
        if (autoHeader) {
          if (!headerMap.containsKey("authorization") && accessToken != null) {
            headerMap["authorization"] = "Bearer $accessToken";
          }
          if (!headerMap.containsKey("user-agent") && userAgent != null) {
            headerMap["user-agent"] = "$userAgent";
          }
        }

        res = await client.get(Uri.parse(url), headers: headerMap);
        // _status.triggerRequest(res);

        if (res.statusCode == 401) {
          await refreshLogin();
          headerMap.remove("authorization");
        } else {
          break;
        }

        // Wait before retrying
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (res == null) throw "Login error";
      if (res.body == 'invalid_grant' || res.body.replaceAll(' ', '') == '') {
        throw "Auth error";
      }

      if (json) {
        return jsonDecode(res.body);
      } else if (rawResponse) {
        return res.bodyBytes;
      } else {
        return res.body;
      }
    } on http.ClientException catch (error) {
      print("ERROR: BKKClient.getAPI ($url) ClientException: ${error.message}");
    } catch (error) {
      print("ERROR: BKKClient.getAPI ($url) ${error.runtimeType}: $error");
    }
  }

  Future<dynamic> postAPI(
    String url, {
    Map<String, String>? headers,
    bool autoHeader = true,
    bool json = true,
    Object? body,
  }) async {
    Map<String, String> headerMap;

    if (headers != null) {
      headerMap = headers;
    } else {
      headerMap = {};
    }

    try {
      http.Response? res;

      for (int i = 0; i < 3; i++) {
        if (autoHeader) {
          if (!headerMap.containsKey("authorization") && accessToken != null) {
            headerMap["authorization"] = "Bearer $accessToken";
          }
          if (!headerMap.containsKey("user-agent") && userAgent != null) {
            headerMap["user-agent"] = "$userAgent";
          }
          if (!headerMap.containsKey("content-type")) {
            headerMap["content-type"] = "application/json";
          }
          if (url.contains('kommunikacio/uzenetek')) {
            headerMap["X-Uzenet-Lokalizacio"] = "hu-HU";
          }
        }

        res = await client.post(Uri.parse(url), headers: headerMap, body: body);
        if (res.statusCode == 401) {
          await refreshLogin();
          headerMap.remove("authorization");
        } else {
          break;
        }
      }

      if (res == null) throw "Login error";

      if (json) {
        print(jsonDecode(res.body));
        return jsonDecode(res.body);
      } else {
        return res.body;
      }
    } on http.ClientException catch (error) {
      print(
          "ERROR: KretaClient.postAPI ($url) ClientException: ${error.message}");
    } catch (error) {
      print("ERROR: KretaClient.postAPI ($url) ${error.runtimeType}: $error");
    }
  }

  Future<void> refreshLogin() async {
    if (_loginRefreshing) return;
    _loginRefreshing = true;

    // UserBKK? loginUser = _user.user;
    // if (loginUser == null) return;

    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded",
    };

    // String nonceStr = const Uuid().v4();

    Map? loginRes = await postAPI(
      BKKAPI.token,
      headers: headers,
      // body: User.loginBody(
      //   username: loginUser.username,
      //   password: loginUser.password,
      //   instituteCode: loginUser.instituteCode,
      // ),
    );

    if (loginRes != null) {
      if (loginRes.containsKey("access_token")) {
        accessToken = loginRes["access_token"];
      }
      if (loginRes.containsKey("refresh_token")) {
        refreshToken = loginRes["refresh_token"];
      }
    }

    if (refreshToken != null) {
      Map? refreshRes = await postAPI(
        BKKAPI.token,
        headers: headers,
      );
      // body: User.refreshBody(
      //     refreshToken: refreshToken!,
      //     instituteCode: loginUser.instituteCode));
      if (refreshRes != null) {
        if (refreshRes.containsKey("id_token")) {
          idToken = refreshRes["id_token"];
        }
      }
    }

    _loginRefreshing = false;
  }

  // web login
  Future<void> webLogin(String nonce, String xQwId, String locale) async {
    Uri finalUrl = Uri.parse(
        '${BKKAPI.authLogin}?nonce=$nonce&rc_native_integration=true&response_type=code&scope=openid%20email%20profile&installation_id=$xQwId&ui_locales=$locale&redirect_uri=https://go.bkk.hu/mobile-redirect/login-final.html&client_id=futar-plusz-ios&state=qwitravel_callback_state');

    if (!await launchUrl(finalUrl, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $finalUrl');
    }
  }
}
