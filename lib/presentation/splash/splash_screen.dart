import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  final String page = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final isOnboardingCompleted = await SharedPrefHelper.isOnboardingCompleted();

    if (!isOnboardingCompleted) {
      getIt<AppRoutes>().replace(OnboardingRoute());
    } else {
      getIt<AppRoutes>().replace(MainRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(splashImage),
            fit: BoxFit.cover,
        )
      ),
    );
  }
}
