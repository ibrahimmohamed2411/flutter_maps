import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/constants/strings.dart';

class LoginScreen extends StatelessWidget {
  late String phoneNumber;
  var _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _phoneFormKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroText(),
                  SizedBox(
                    height: 110,
                  ),
                  _buildPhoneFormField(),
                  SizedBox(
                    height: 70,
                  ),
                  _buildNextButton(context),
                  _buildPhoneNumberSubmittedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmittedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmitted) {
          Navigator.pop(context); //cancel dialog
          Navigator.of(context).pushNamed(
            otpScreen,
            arguments: phoneNumber,
          );
        }
        if (state is ErrorOccurred) {
          Navigator.of(context).pop();
          String errorMsg = state.errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
    );
  }

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your phone number ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Please enter your phone number to verify your account.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.lightGrey),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              generateCountryFlag() + ' +20',
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
          ),
          flex: 1,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.blue),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length < 11) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
          showProgressIndicator(context);
          _register(context);
        },
        child: Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(110, 50),
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.of(context).pop();
      return;
    } else {
      Navigator.of(context).pop();
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }
}
