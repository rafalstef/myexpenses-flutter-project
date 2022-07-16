import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.textEditingController,
    this.onChanged,
    this.textInputType,
    this.autoFocus = false,
    this.textInputAction,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.errorText,
    this.validator,
    this.prefixIcon,
    this.focusBorderColor,
    this.contentPadding,
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool autoFocus;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Color? focusBorderColor;
  final EdgeInsets? contentPadding;

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
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
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
      labelText: widget.labelText,
      hintText: widget.hintText,
      hintStyle: AppTextStyles.regular(AppColors.dark20),
      focusedBorder: _border(widget.focusBorderColor == null
          ? AppColors.violet80
          : widget.focusBorderColor!),
      enabledBorder: _border(AppColors.light20),
      border: _border(AppColors.dark100),
      errorBorder: _border(AppColors.red100),
      focusedErrorBorder: _border(AppColors.red100),
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints:
          const BoxConstraints(minHeight: 24, minWidth: 24),
      suffixIcon: (widget.obscureText) ? _buildVisibilityIcon() : null,
      isDense: true,
    );
  }

  OutlineInputBorder _border(Color color) =>
      AppDecorations.input.outlineBorder(color: color);

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
