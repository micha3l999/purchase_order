import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/routes/pages.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class MyApp extends StatefulWidget {
  final String initialWidget;
  const MyApp({Key? key, this.initialWidget = Pages.initial}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  /*static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }*/
}

class _MyAppState extends State<MyApp> {
  //late Locale _locale;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Orden de compra",
        initialRoute: widget.initialWidget,
        routes: Pages.routes,
        theme: ThemeData(
          appBarTheme: Theme.of(context)
              .appBarTheme
              .copyWith(brightness: Brightness.dark),
          primaryColor: primaryColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
          textTheme: Fonts.textTheme,
        ),
        /*locale: _locale,
        supportedLocales: const [
          Locale('es', ''),
          Locale('en', ''),
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },*/
      ),
    );
  }

  /*void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }*/
}
