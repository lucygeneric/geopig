import 'package:flutter/cupertino.dart';
import 'package:geopig/widgets/input.dart';

class SmsCodeInput extends StatefulWidget {

  final Function onFinished;

  SmsCodeInput({@required this.onFinished});

  @override
  _SmsCodeInputState createState() => _SmsCodeInputState();
}

class _SmsCodeInputState extends State<SmsCodeInput> {

  List<TextEditingController> codeControllers = [];

  @override
  void initState(){
    for (int i = 0; i <= 5; i++) { codeControllers.add(TextEditingController());}
    super.initState();
  }

  List<Widget> get codeInputs  => codeControllers.map((TextEditingController controller) =>
    Input(
      controller: controller,
      maxLength: 1,

  )).toList();

  @override
  Widget build(BuildContext context) {
    return Row(children: codeInputs.map((Widget input){
      if(input != codeInputs.last)
        return Flexible(child: Container(padding: EdgeInsets.only(right: 5.0), child: input));
      return input;
    }).toList());
  }
}