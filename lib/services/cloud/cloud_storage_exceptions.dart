class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotGetAllAccountsException extends CloudStorageException {}

class CouldNotCreateUpdateAccountException extends CloudStorageException {}

class CouldNotDeleteAccountException extends CloudStorageException {}

class CouldNotGetAllCategoriesException extends CloudStorageException {}

class CouldNotCreateUpdateCategoryException extends CloudStorageException {}

class CouldNotDeleteCategoryException extends CloudStorageException {}

class CouldNotGetAllExpensesException extends CloudStorageException {}

class CouldNotCreateUpdateExpenseException extends CloudStorageException {}

class CouldNotDeleteExpenseException extends CloudStorageException {}

class CouldNotGetAccountAmountException extends CloudStorageException {}
