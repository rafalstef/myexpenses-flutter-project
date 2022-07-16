part of 'app_decorations.dart';

class _Input {
  const _Input();

  OutlineInputBorder outlineBorder({required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    );
  }
}
