import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';

class ListPreferences {
  ListPreferences({
    required this.userTransactions,
    required this.sortMethod,
    required this.startDate,
    required this.endDate,
    required this.filteredAccountIds,
  });
  final List<UserTransaction> userTransactions;
  final SortMethod sortMethod;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> filteredAccountIds;
}
