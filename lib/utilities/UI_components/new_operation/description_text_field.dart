import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/utilities/UI_components/input_fields/app_text_field.dart';

class DescriptionTextField extends StatefulWidget {
  final String description;
  final Color iconColor;
  final ValueChanged<String> onChanged;

  const DescriptionTextField({
    Key? key,
    required this.description,
    required this.onChanged,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    controller.text = widget.description;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      textEditingController: controller,
      onChanged: widget.onChanged,
      focusBorderColor: AppColors.light20,
      textInputAction: TextInputAction.done,
      hintText: 'Description',
      autoFocus: false,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 24.0,
        ),
        child: Icon(
          Icons.description_rounded,
          size: 20,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
