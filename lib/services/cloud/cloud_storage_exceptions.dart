class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateAccountException extends CloudStorageException {}

class CouldNotGetAllAccountsException extends CloudStorageException {}

class CouldNotCreateUpdateAccontException extends CloudStorageException {}

class CouldNotDeleteAccountException extends CloudStorageException {}
