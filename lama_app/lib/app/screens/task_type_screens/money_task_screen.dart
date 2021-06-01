import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class MoneyTaskScreen extends StatelessWidget{
  final TaskMoney task;
  final BoxConstraints constraints;

  double finalMoneyAmount;
  double currentAmountDouble;
  String currentAmountString;

  MoneyTaskScreen(this.task, this.constraints){
    finalMoneyAmount = task.moneyAmount;
    print(finalMoneyAmount.toStringAsFixed(2));
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 15,
        padding: EdgeInsets.only(left: 15, right: 15),
        // create space between each childs
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 75),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Bubble(
                  nip: BubbleNip.leftCenter,
                  child: Center(
                    child: Text(
                      task.lamaText,
                      style:
                      LamaTextTheme.getStyle(color: LamaColors.black, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                "assets/images/svg/lama_head.svg",
                semanticsLabel: "Lama Anna",
                width: 75,
              ),
            )
          ],
        ),
      ),
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.all(5),
        child: Container(
          height: (constraints.maxHeight / 100) * 6,
          width: (constraints.maxHeight / 100) * 30,
          color: LamaColors.orangeAccent,
        ),
      )
    ]);
  }

}