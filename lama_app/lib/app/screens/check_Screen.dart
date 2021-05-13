import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/db/database_provider.dart';

class CheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/svg/lama_head.svg',
          semanticsLabel: 'LAMA',
        ),
      ),
    );
  }
}
