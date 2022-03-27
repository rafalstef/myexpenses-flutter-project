class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateAccountException extends CloudStorageException {}

class CouldNotGetAllAccountsException extends CloudStorageException {}

class CouldNotCreateUpdateAccountException extends CloudStorageException {}

class CouldNotDeleteAccountException extends CloudStorageException {}
