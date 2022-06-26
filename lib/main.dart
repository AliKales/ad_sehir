import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase_options.dart';
import 'package:ad_sehir/pages/end_page.dart';
import 'package:ad_sehir/pages/home_page.dart';
import 'package:ad_sehir/pages/room_page.dart';
import 'package:ad_sehir/provider/provider_end_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderGameSettings>(
          create: (_) => ProviderGameSettings(),
        ),
        ChangeNotifierProvider<ProviderRoomPage>(
          create: (_) => ProviderRoomPage(),
        ),
        ChangeNotifierProvider<ProviderEndPage>(
          create: (_) => ProviderEndPage(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => const HomePage(), settings: settings);
      },
      onGenerateInitialRoutes: (navigator) {
        return [generateRoute(navigator, null)];
      },
      onGenerateRoute: (settings) {
        return generateRoute(settings.name ?? "", settings);
      },
      title: 'İsim Şehir',
      theme: ThemeData(
        dividerColor: color3,
        dividerTheme: DividerThemeData(
          color: color3,
          thickness: 4
        ),
        appBarTheme:
            const AppBarTheme(backgroundColor: color1, foregroundColor: color4),
        iconTheme: const IconThemeData(color: color4),
        primarySwatch: CustomColor().getMaterialColor(
            color4.red, color4.green, color4.blue, color4.value),
        primaryColor: color4,
        primaryTextTheme: textThemeTexts(),
        textTheme: textThemeTexts(),
        tooltipTheme: TooltipTheme.of(context).copyWith(
            textStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white)),
        scrollbarTheme: const ScrollbarThemeData()
            .copyWith(thumbColor: MaterialStateProperty.all(Colors.grey[500])),
      ), //fontFamily: "RobotoSlab-Regular"),
    );
  }

  TextTheme textThemeTexts() {
    return const TextTheme(
      headline6: TextStyle(color: color4),
      subtitle1: TextStyle(color: color4),
      bodyText2: TextStyle(color: color4),
      bodyText1: TextStyle(color: color4),
    );
  }

  dynamic generateRoute(String link, RouteSettings? settings) {
    // return MaterialPageRoute(
    //     builder: (_) => EndPage(), settings: settings);
    Map params = {};
    if (link.contains("?")) {
      List<String> paramsList = link.split("?")[1].split("&");

      for (var item in paramsList) {
        params[item.split("=")[0]] = item.split("=")[1];
      }
    }

    if (link.contains("room")) {
      return MaterialPageRoute(
          builder: (_) => RoomPage(roomId: params['r']), settings: settings);
    }
    return MaterialPageRoute(
        builder: (_) => const HomePage(), settings: settings);
  }
}
