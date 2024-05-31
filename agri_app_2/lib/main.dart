import 'package:agri_app_2/crop/presentation/add_crop.dart';
import 'package:agri_app_2/crop/presentation/crop_management.dart';
import 'package:agri_app_2/order/presentation/farmer_order_display.dart';
import 'package:agri_app_2/order/presentation/order_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import 'auth/data_provider/signin_data_provider.dart';
import 'auth/repository/signin_repo.dart';
import 'crop/data_provider/crop_data_provider.dart' as crop_data_provider;
import 'crop/repository/crop_repository.dart' as crop_repository;
import 'order/data_provider/order_data_provider.dart';
import 'order/repository/order_repository.dart';
import 'presentation/screens/dash_board.dart';
import 'presentation/screens/landing_page.dart';
import 'presentation/screens/signup.dart';
import 'presentation/screens/login.dart';
import 'presentation/widget/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        authDataProviderProvider.overrideWithValue(AuthDataProvider(dio)),
        cropDataProviderProvider.overrideWithValue(
            crop_data_provider.CropDataProvider(dio, sharedPreferences)),
        orderDataProviderProvider
            .overrideWithValue(OrderDataProvider(dio, sharedPreferences)),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(),
    ),
  );
}

final authDataProviderProvider = Provider<AuthDataProvider>((ref) {
  final dio = Dio();
  return AuthDataProvider(dio);
});

final cropDataProviderProvider =
    Provider<crop_data_provider.CropDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return crop_data_provider.CropDataProvider(dio, sharedPreferences);
});

final orderDataProviderProvider = Provider<OrderDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return OrderDataProvider(dio, sharedPreferences);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Properly handle async initialization
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataProvider = ref.watch(authDataProviderProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthRepository(authDataProvider, sharedPreferences);
});

final cropRepositoryProvider = Provider<crop_repository.CropRepository>((ref) {
  final cropDataProvider = ref.watch(cropDataProviderProvider);
  return crop_repository.ConcreteCropRepository(cropDataProvider);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final orderDataProvider = ref.watch(orderDataProviderProvider);
  return ConcreteOrderRepository(orderDataProvider: orderDataProvider);
});

final themeProviderProvider = ChangeNotifierProvider<ThemeProvider>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final isDark = prefs.getBool("isDark") ?? false;
  return ThemeProvider(isDark: isDark);
});

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderProvider);

    return MaterialApp.router(
      title: 'Flutter Theme',
      theme: themeProvider.getTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/signUp',
        builder: (context, state) => SignUp(),
      ),
      GoRoute(
        path: '/logIn',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashBoard',
        builder: (context, state) => const DashBoardScreen(),
      ),
      GoRoute(
        path: '/cropManagement',
        builder: (context, state) => const CropMangement(),
      ),
      GoRoute(
        path: '/addCrop',
        builder: (context, state) => const AddCrop(),
      ),
      GoRoute(
        path: '/orderDisplayBuyer',
        builder: (context, state) => const OrderDisplayScreen(),
      ),
      GoRoute(
        path: '/orderDisplayFarmer',
        builder: (context, state) => const FarmerOrderDisplay(),
      ),
    ],
    errorBuilder: (context, state) => const UnknownRoutePage(),
  );
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
