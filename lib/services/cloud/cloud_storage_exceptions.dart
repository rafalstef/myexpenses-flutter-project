class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateAccountException extends CloudStorageException {}

class CouldNotGetAllAccountsException extends CloudStorageException {}

class CouldNotCreateUpdateAccountException extends CloudStorageException {}

class CouldNotDeleteAccountException extends CloudStorageException {}

class CouldNotCreateCategoryException extends CloudStorageException {}

class CouldNotGetAllCategoriesException extends CloudStorageException {}

class CouldNotCreateUpdateCategoryException extends CloudStorageException {}

class CouldNotDeleteCategoryException extends CloudStorageException {}
