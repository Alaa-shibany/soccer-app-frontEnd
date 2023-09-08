import 'package:flutter/material.dart';

class PasswrdTextFild extends StatefulWidget {
  final TextEditingController passwordController;
  final FocusNode password;
  final Map<String, String> newValue;
  PasswrdTextFild(
      {super.key,
      required this.passwordController,
      required this.newValue,
      required this.password});

  @override
  State<PasswrdTextFild> createState() => _PasswrdTextFildState();
}

class _PasswrdTextFildState extends State<PasswrdTextFild> {
  var obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.password,
      onChanged: (value) {
        setState(() {
          widget.newValue['password'] = value;
        });
      },
      controller: widget.passwordController,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: obscureText
              ? const Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                )
              : const Icon(
                  Icons.visibility,
                  color: Color.fromARGB(255, 46, 47, 112),
                ),
        ),
        border: InputBorder.none,
        hintText: 'Password',
      ),
    );
  }
}
