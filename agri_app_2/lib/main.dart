import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/login_main.dart';
import 'package:agri_app_2/auth/repository/signin_repo.dart';
import 'package:agri_app_2/auth/signup_main.dart';
import 'package:agri_app_2/crop/data_provider/crop_data_provider.dart'
    as crop_data_provider;
import 'package:agri_app_2/crop/presentation/add_crop.dart';
import 'package:agri_app_2/crop/presentation/crop_management.dart';
import 'package:agri_app_2/crop/repository/crop_repository.dart'
    as crop_repository;
import 'package:agri_app_2/order/data_provider/order_data_provider.dart';
import 'package:agri_app_2/order/repository/order_repository.dart';
import 'package:agri_app_2/presentation/screens/dash_board.dart';
import 'package:agri_app_2/order/presentation/farmer_order_display.dart';
import 'package:agri_app_2/presentation/screens/landing_page.dart';

import 'package:agri_app_2/order/presentation/order_display.dart';
import 'package:agri_app_2/presentation/widget/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    riverpod.ProviderScope(
      overrides: [
        authDataProviderProvider.overrideWithValue(AuthDataProvider(dio)),
        cropDataProviderProvider.overrideWithValue(
            crop_data_provider.CropDataProvider(dio, sharedPreferences)),
        orderDataProviderProvider
            .overrideWithValue(OrderDataProvider(dio, sharedPreferences)),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

final authDataProviderProvider = riverpod.Provider<AuthDataProvider>((ref) {
  final dio = Dio();
  return AuthDataProvider(dio);
});

final cropDataProviderProvider =
    riverpod.Provider<crop_data_provider.CropDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return crop_data_provider.CropDataProvider(dio, sharedPreferences);
});

final orderDataProviderProvider = riverpod.Provider<OrderDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return OrderDataProvider(dio, sharedPreferences);
});

final sharedPreferencesProvider = riverpod.Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Properly handle async initialization
});

final authRepositoryProvider = riverpod.Provider<AuthRepository>((ref) {
  final authDataProvider = ref.watch(authDataProviderProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthRepository(authDataProvider, sharedPreferences);
});

final cropRepositoryProvider =
    riverpod.Provider<crop_repository.CropRepository>((ref) {
  final cropDataProvider = ref.watch(cropDataProviderProvider);
  return crop_repository.ConcreteCropRepository(cropDataProvider);
});

final orderRepositoryProvider = riverpod.Provider<OrderRepository>((ref) {
  final orderDataProvider = ref.watch(orderDataProviderProvider);
  return ConcreteOrderRepository(orderDataProvider: orderDataProvider);
});

class MyApp extends riverpod.ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderProvider);
    return themeProvider.when(
      data: (theme) => MaterialApp(
        title: 'Flutter Theme',
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/signUp': (context) => const MySignup(),
          '/logIn': (context) => const MyLogin(),
          '/dashBoard': (context) => const DashBoardScreen(),
          '/cropManagement': (context) => const CropMangement(),
          '/addCrop': (context) => const AddCrop(),
          '/orderDisplayBuyer': (context) => const OrderDisplayScreen(),
          '/orderDisplayFarmer': (context) => const FarmerOrderDisplay(),
        },
        theme: theme.getTheme,
        debugShowCheckedModeBanner: false,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const UnknownRoutePage(),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $err'),
          ),
        ),
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}

final themeProviderProvider =
    riverpod.FutureProvider<ThemeProvider>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool("isDark") ?? false;
  return ThemeProvider(isDark: isDark);
});
