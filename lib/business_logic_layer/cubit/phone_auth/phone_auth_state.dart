part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState {}

class ErrorOccurred extends PhoneAuthState {
  final String errorMessage;
  ErrorOccurred({required this.errorMessage});
}

class PhoneNumberSubmitted extends PhoneAuthState {}

class PhoneOTPVerified extends PhoneAuthState {}
