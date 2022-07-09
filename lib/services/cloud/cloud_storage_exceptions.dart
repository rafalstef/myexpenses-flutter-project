class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotGetAllAccountsException extends CloudStorageException {}

class CouldNotCreateUpdateAccountException extends CloudStorageException {}

class CouldNotDeleteAccountException extends CloudStorageException {}

class CouldNotGetAllCategoriesException extends CloudStorageException {}

class CouldNotCreateUpdateCategoryException extends CloudStorageException {}

class CouldNotDeleteCategoryException extends CloudStorageException {}

class CouldNotGetAllOperationsException extends CloudStorageException {}

class CouldNotCreateUpdateOperationException extends CloudStorageException {}

class CouldNotDeleteOperationException extends CloudStorageException {}

class CouldNotGetAccountAmountException extends CloudStorageException {}

class CouldNotGetUserNameExcepion extends CloudStorageException {}
