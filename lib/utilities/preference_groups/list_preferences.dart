import 'package:myexpenses/enums/sort_method.dart';

class ListPreferences {
  ListPreferences({
    required this.sortMethod,
    required this.startDate,
    required this.endDate,
    required this.filteredAccountIds,
  });
  final SortMethod sortMethod;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> filteredAccountIds;
}
