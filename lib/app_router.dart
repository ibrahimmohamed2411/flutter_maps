import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/presentation_layer/screens/login_screen.dart';
import 'package:flutter_maps/presentation_layer/screens/map_screen.dart';
import 'package:flutter_maps/presentation_layer/screens/otp_screen.dart';

import 'constants/strings.dart';

class AppRouter {
  late PhoneAuthCubit phoneAuthCubit;
  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: phoneAuthCubit,
            child: LoginScreen(),
          ),
        );
      case otpScreen:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: phoneAuthCubit,
            child: OTPScreen(phoneNumber: phoneNumber),
          ),
        );
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => MapScreen(),
        );
    }
  }
}
