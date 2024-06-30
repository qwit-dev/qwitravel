import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwitravel/api/client.dart';
import 'package:qwitravel/api/endpoints.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  var currentUrl = '';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) async {
          setState(() {
            loadingPercentage = 0;
            currentUrl = url;
          });

          List<String> requiredThings = url
              .replaceAll('https://go.bkk.hu/?session_state=', '')
              .split('&code=');

          String code = requiredThings[0];
          // String sessionState = requiredThings[1];

          debugPrint('url: $url');

          // actual login (token grant) logic
          Map<String, String> headers = {
            "content-type": "application/json",
            "accept": "application/json",
            "user-agent": BKKAPI.userAgent,
          };

          Map? res = await Provider.of<BKKClient>(context, listen: false)
              .postAPI(BKKAPI.token, headers: headers, body: {
            "code": code,
            "redirect_uri": "https://go.bkk.hu",
            "client_id": BKKAPI.clientId,
            "grant_type": "authorization_code",
          });
          if (res != null) {
            if (kDebugMode) {
              print(res);
            }
          }

          print('code: $code');

          // if (res.containsKey("error")) {
          //   if (res["error"] == "invalid_grant") {
          //     print("ERROR: invalid_grant");
          //     return;
          //   }
          // } else {
          //   if (res.containsKey("access_token")) {
          //     try {
          //       Provider.of<KretaClient>(context, listen: false).accessToken =
          //           res["access_token"];
          //       Map? studentJson =
          //           await Provider.of<KretaClient>(context, listen: false)
          //               .getAPI(KretaAPI.student(instituteCode));
          //       Student student = Student.fromJson(studentJson!);
          //       var user = User(
          //         username: username,
          //         password: password,
          //         instituteCode: instituteCode,
          //         name: student.name,
          //         student: student,
          //         role: JwtUtils.getRoleFromJWT(res["access_token"])!,
          //       );

          //       if (onLogin != null) onLogin(user);

          //       // Store User in the database
          //       await Provider.of<DatabaseProvider>(context, listen: false)
          //           .store
          //           .storeUser(user);
          //       Provider.of<UserProvider>(context, listen: false)
          //           .addUser(user);
          //       Provider.of<UserProvider>(context, listen: false)
          //           .setUser(user.id);

          //       // Get user data
          //       try {
          //         await Future.wait([
          //           Provider.of<GradeProvider>(context, listen: false)
          //               .fetch(),
          //           Provider.of<TimetableProvider>(context, listen: false)
          //               .fetch(week: Week.current()),
          //           Provider.of<ExamProvider>(context, listen: false).fetch(),
          //           Provider.of<HomeworkProvider>(context, listen: false)
          //               .fetch(),
          //           Provider.of<MessageProvider>(context, listen: false)
          //               .fetchAll(),
          //           Provider.of<MessageProvider>(context, listen: false)
          //               .fetchAllRecipients(),
          //           Provider.of<NoteProvider>(context, listen: false).fetch(),
          //           Provider.of<EventProvider>(context, listen: false)
          //               .fetch(),
          //           Provider.of<AbsenceProvider>(context, listen: false)
          //               .fetch(),
          //         ]);
          //       } catch (error) {
          //         print("WARNING: failed to fetch user data: $error");
          //       }

          //       if (onSuccess != null) onSuccess();

          //       return LoginState.success;
          //     } catch (error) {
          //       print("ERROR: loginAPI: $error");
          //       // maybe check debug mode
          //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));
          //       return LoginState.failed;
          //     }
          //   }
          // }
          // }
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(
            "${BKKAPI.authLogin}?client_id=${BKKAPI.clientId}&response_type=code&redirect_uri=https://go.bkk.hu"),
      );
  }

  // Future<void> loadLoginUrl() async {
  //   String nonceStr = await Provider.of<KretaClient>(context, listen: false)
  //         .getAPI(KretaAPI.nonce, json: false);

  //     Nonce nonce = getNonce(nonceStr, );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('BudapestGO | Bejelentkezés'),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
