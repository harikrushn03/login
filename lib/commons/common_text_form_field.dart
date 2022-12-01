import 'package:flutter/material.dart';

import 'common_helper.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintName;
  final IconData? icon;
  final bool? isObscureText;
  final TextInputType? inputType;
  final bool? isEnable;

  const CommonTextFormField({
    Key? key,
    this.controller,
    this.hintName,
    this.icon,
    this.isObscureText = false,
    this.inputType,
    this.isEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText!,
        enabled: isEnable,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          }
          if (hintName == "Email" && !validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(icon),
          hintText: hintName,
          labelText: hintName,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}
