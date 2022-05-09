import 'package:myexpenses/enums/sort_method.dart';

class ListPreferences {
  ListPreferences({
    required this.sortMethod,
    required this.preferedMonth,
    required this.filteredAccountIds,
  });
  final SortMethod sortMethod;
  final DateTime preferedMonth;
  final List<String> filteredAccountIds;
}
