import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ApiKeyMissingFailure extends Failure {
  const ApiKeyMissingFailure() : super('API Key Missing');
}

class ExportFailure extends Failure {
  const ExportFailure(super.message);
}

class RefineFailure extends Failure {
  const RefineFailure(super.message);
}
