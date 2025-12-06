import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'config/app_routes.dart';
import 'config/locale_config.dart';
import 'logic/cubits/auth_cubit.dart';
import 'logic/cubits/products_cubit.dart';
import 'logic/cubits/orders_cubit.dart';
import 'logic/cubits/statistics_cubit.dart';
import 'logic/cubits/profile_cubit.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/products_repository.dart';
import 'data/repositories/orders_repository.dart';
import 'data/repositories/statistics_repository.dart';
import 'data/repositories/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = LocaleConfig.defaultLocale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedLocale = await LocaleConfig.getSavedLocale();
    setState(() {
      _locale = savedLocale;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    LocaleConfig.saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(ProductsRepository()),
        ),
        BlocProvider(
          create: (context) => OrdersCubit(OrdersRepository()),
        ),
        BlocProvider(
          create: (context) => StatisticsCubit(StatisticsRepository()),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(ProfileRepository()),
        ),
      ],
      child: MaterialApp(
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocaleConfig.supportedLocales,
        initialRoute: AppRoutes.welcome,
        routes: routes,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return _LocaleProvider(
            changeLocale: _changeLocale,
            child: child!,
          );
        },
      ),
    );
  }
}

class _LocaleProvider extends InheritedWidget {
  final Function(Locale) changeLocale;

  const _LocaleProvider({
    required this.changeLocale,
    required super.child,
  });

  static _LocaleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LocaleProvider>();
  }

  @override
  bool updateShouldNotify(_LocaleProvider oldWidget) {
    return changeLocale != oldWidget.changeLocale;
  }
}

extension LocaleExtension on BuildContext {
  void changeLocale(Locale locale) {
    _LocaleProvider.of(this)?.changeLocale(locale);
  }
}
