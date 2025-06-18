import 'package:flutter/material.dart';
import 'package:flutter_internship_task/core/utils/colors.dart';
import 'package:flutter_internship_task/core/utils/enum/enum.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, widget, {bool replace = false}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => !replace,
    );

Widget defaultTextButton({required function, required String text}) =>
    TextButton(onPressed: function, child: Text(text.toUpperCase()));

Widget defaultButton({
  required function,
  required String text,
  radius = 3.0,
  width = double.infinity,
  Color background = primaryColor,
  isUpperCase = true,
}) => Container(
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radius),
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(isUpperCase ? text.toUpperCase() : text),
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  required String? Function(String? value) validate,
  required String label,
  required IconData prefixIcon,
  bool isPassword = false,
  Widget? suffixIcon,
  VoidCallback? suffixFunction,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    border: OutlineInputBorder(),
    suffixIcon:
        suffixIcon != null
            ? IconButton(icon: suffixIcon, onPressed: suffixFunction)
            : null,
  ),
  obscureText: isPassword,
);

Future<bool?> showToast({
  required String message,
  required ToastStates state,
}) => Fluttertoast.showToast(
  msg: message!,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: selectColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

Color selectColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
