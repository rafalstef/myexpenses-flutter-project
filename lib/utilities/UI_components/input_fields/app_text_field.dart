import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.textEditingController,
    this.onChanged,
    this.textInputType,
    this.autoFocus = false,
    this.textInputAction,
    this.obscureText = false,
    this.labelText,
    this.errorText,
    this.validator,
    this.prefixIconData,
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? errorText;
  final bool autoFocus;
  final IconData? prefixIconData;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  final BorderRadius _inputBorderRadius = BorderRadius.circular(16.0);

  late FocusNode focusNode;
  late bool hasFocus;
  late bool isTextHidden;

  @override
  void initState() {
    super.initState();
    isTextHidden = widget.obscureText;
    hasFocus = false;
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasPrimaryFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autofocus: widget.autoFocus,
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      obscureText: isTextHidden,
      cursorColor: AppColors.dark100,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 22.0,
          horizontal: 16.0,
        ),
        labelText: widget.labelText,
        focusedBorder: _outlineFocusedInputBorder(color: AppColors.violet80),
        enabledBorder: _outlineFocusedInputBorder(color: AppColors.light20),
        border: _outlineFocusedInputBorder(color: AppColors.dark100),
        errorBorder: _outlineRegularInputBorder(color: AppColors.red100),
        focusedErrorBorder: _outlineFocusedInputBorder(color: AppColors.red100),
        prefixIcon: widget.prefixIconData != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8),
                child: Icon(widget.prefixIconData, size: 20))
            : null,
        prefixIconConstraints:
            const BoxConstraints(minHeight: 24, minWidth: 24),
        suffixIcon: (widget.obscureText) ? _buildVisibilityIcon() : null,
        isDense: true,
      ),
    );
  }

  OutlineInputBorder _outlineFocusedInputBorder({required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
      borderRadius: _inputBorderRadius,
    );
  }

  OutlineInputBorder _outlineRegularInputBorder({required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.25),
      borderRadius: _inputBorderRadius,
    );
  }

  IconButton _buildVisibilityIcon() {
    return IconButton(
      onPressed: () {
        setState(() {
          isTextHidden = !isTextHidden;
        });
      },
      icon: Icon(isTextHidden
          ? Icons.visibility_off_rounded
          : Icons.visibility_rounded),
      iconSize: 24.0,
      splashColor: AppColors.transparent,
      padding: const EdgeInsets.only(right: 12.0),
    );
  }
}
