import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
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
  final bool Function(String)? validator;
  final bool obscureText;

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final BorderRadius _inputBorderRadius = BorderRadius.circular(16.0);

  late FocusNode focusNode;
  late bool hasConfirmation;
  late bool hasError;
  late bool hasFocus;
  late bool isTextHidden;

  @override
  void initState() {
    super.initState();
    isTextHidden = widget.obscureText;
    hasFocus = false;
    hasConfirmation = isValid;
    hasError = !isValid;
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasPrimaryFocus;
        bool valid = isValid;
        hasConfirmation = valid;
        hasError = !valid;
      });
    });
  }

  bool get isValid {
    if (hasValidator) {
      return widget.validator!(widget.textEditingController.text);
    }
    return false;
  }

  bool get hasValidator {
    return widget.validator != null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      autofocus: widget.autoFocus,
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      obscureText: isTextHidden,
      cursorColor: AppColors.dark100,
      textInputAction: widget.textInputAction,
      onChanged: _onChangedTextField,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 22.0,
          horizontal: 16.0,
        ),
        labelText: widget.labelText,
        errorText: widget.errorText != null && hasError && hasValidator
            ? widget.errorText
            : null,
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

  void _onChangedTextField(val) {
    setState(() {
      hasError = false;
      hasConfirmation = isValid;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
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
