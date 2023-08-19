import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initInfo();
  }

  Future<List<AppInfo>> initInfo() async {
    return await InstalledApps.getInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AppInfo>>(
        future: initInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data![index].name!),
                            Text(snapshot.data![index].packageName!),
                            Text(snapshot.data![index].versionCode!
                                .round()
                                .toString()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          admInstalled(snapshot.data!),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String _url = "https://dl.musicdel.ir/tag/music/1401/12/09/Rauf%20Faik%20-%20kolybelnaya%20(320).mp3";
                            // Uri _uri = Uri.parse(
                                // "https://dl.rozmusic.com/Music/1402/05/28/Amin%20Rostami%20-%20Ba%20Mani.mp3");
                            // if (await canLaunchUrl(_uri)) {
                            //   launchUrl(_uri,mode: LaunchMode.externalApplication);
                            // }
                                
                            if (Platform.isAndroid) {
                              AndroidIntent intent = AndroidIntent(
                                action: 'action_main',
                                package: "com.dv.adm",
                                componentName: "com.dv.adm.AEditor",
                                arguments: {'android.intent.extra.TEXT': _url},
                              );
                              await intent.launch();
                            }
                          },
                          child: Text("Send Link To ADM"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text('Out Of Rage'),
          );
        },
      ),
    );
  }
}

String admInstalled(List<AppInfo> infoApp) {
  for (var element in infoApp) {
    return element.packageName == "com.dv.adm"
        ? "ADM is Installed"
        : "ADM is not Installed";
  }
  return "";
}
