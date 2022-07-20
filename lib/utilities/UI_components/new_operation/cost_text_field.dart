import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class CostTextField extends StatefulWidget {
  final double cost;
  final ValueChanged<String> onChanged;

  const CostTextField({
    Key? key,
    required this.cost,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CostTextField> createState() => _CostTextFieldState();
}

class _CostTextFieldState extends State<CostTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    if (widget.cost != 0) {
      controller.text = widget.cost.toStringAsFixed(2);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  OutlineInputBorder get _transparentBorder =>
      AppDecorations.input.outlineBorder(color: AppColors.transparent);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.left,
      showCursor: false,
      style: AppTextStyles.titleX(AppColors.light80),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
      ],
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: AppTextStyles.titleX(AppColors.light80),
        prefixIcon: Text('\$', style: AppTextStyles.titleX(AppColors.light80)),
        border: _transparentBorder,
        focusedBorder: _transparentBorder,
        enabledBorder: _transparentBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
    );
  }
}
