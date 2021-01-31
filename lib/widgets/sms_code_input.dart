import 'package:flutter/cupertino.dart';
import 'package:geopig/widgets/input.dart';

class SmsCodeInput extends StatefulWidget {

  final Function onFinished;
  final bool enabled;

  SmsCodeInput({@required this.onFinished, this.enabled = true});

  @override
  _SmsCodeInputState createState() => _SmsCodeInputState();
}

class _SmsCodeInputState extends State<SmsCodeInput> {

  List<TextEditingController> codeControllers = [];
  List<FocusNode> codeFocusNodes  = [];
  bool complete = false;

  @override
  void initState(){
    for (int i = 0; i <= 5; i++) { codeControllers.add(TextEditingController());}
    for (int i = 0; i <= 5; i++) { codeFocusNodes.add(FocusNode());}
    super.initState();
  }

  List<Input> get codeInputs => codeControllers.map((TextEditingController controller) =>
    Input(
      controller: controller,
      maxLength: 1,
      enabled: widget.enabled,
      textAlign: TextAlign.center,
      focusNode: codeFocusNodes[codeControllers.indexOf(controller)],
      onChanged: (String value) => focusNext()
  )).toList();

  void focusNext(){
    Input nextEmpty = codeInputs.firstWhere((Input input) => input.controller.text == "", orElse: () => null);
    if (nextEmpty != null){
      // sometimes things happen and this widget becomes disabled...
      widget.enabled ? nextEmpty.focusNode.requestFocus() : defocus();
    } else {
      complete = true;
      defocus();
      widget.onFinished(codeControllers.map((e) => e.text).toList().join(""));
    }
  }

  void defocus() => FocusScope.of(context).requestFocus(new FocusNode());

  @override
  Widget build(BuildContext context) {

    // if this widget is enabled force focus the the next empty controller
    if (!complete) focusNext();

    return Row(children: codeInputs.map((Widget input){
        if(input != codeInputs.last)
          return Flexible(child: Container(padding: EdgeInsets.only(right: 5.0), child: input));
        return input;
      }).toList());
  }
}