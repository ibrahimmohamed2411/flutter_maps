import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constants/strings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (cyx) => phoneAuthCubit,
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                //BlocProvider.of<PhoneAuthCubit>(context).signOut();
                phoneAuthCubit.signOut();
                Navigator.of(context).pushReplacementNamed(loginScreen);
              },
              child: Text(
                'Logout',
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
          ),
        ),
      ),
    );
  }
}
