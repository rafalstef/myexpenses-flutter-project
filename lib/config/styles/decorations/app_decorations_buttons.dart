part of 'app_decorations.dart';

class _Button {
  const _Button();

  BoxDecoration roundedBorder() {
    return BoxDecoration(
      border: Border.all(color: AppColors.light20, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    );
  }
}
