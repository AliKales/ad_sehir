import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/pages/home_page.dart';
import 'package:ad_sehir/pages/room_create_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderGameSettings>(
          create: (_) => ProviderGameSettings(),
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
        iconTheme: const IconThemeData(color: color4),
        primarySwatch: CustomColor().getMaterialColor(
            color4.red, color4.green, color4.blue, color4.value),
        primaryColor: color4,
        textTheme: const TextTheme(
          headline6: TextStyle(color: color4),
          subtitle1: TextStyle(color: color4),
        ),
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

  dynamic generateRoute(String link, RouteSettings? settings) {
    return MaterialPageRoute(
        builder: (_) => RoomCreatePage(), settings: settings);
  }
}
