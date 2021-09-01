import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;
  PhoneAuthCubit() : super(PhoneAuthInitial());
  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verification completed');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print('verification field');
    emit(ErrorOccurred(errorMessage: exception.message.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print('code sent');
    this.verificationId = verificationId;
    emit(PhoneNumberSubmitted());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print(verificationId);
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpCode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
    } on FirebaseAuthException catch (e) {
      emit(ErrorOccurred(errorMessage: e.message.toString()));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    return FirebaseAuth.instance.currentUser!;
  }
}
