import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  /// 사용자에게 표시할 친화적 메시지
  String get userMessage;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  String get userMessage => '서버 연결에 실패했습니다. 인터넷 연결을 확인해주세요.';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  String get userMessage => '데이터 저장에 실패했습니다. 앱을 다시 시작해주세요.';
}

class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);

  @override
  String get userMessage => '데이터를 처리하는 중 오류가 발생했습니다.';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  String get userMessage => '인터넷 연결을 확인해주세요.';
}
