import 'package:uuid/uuid.dart';

String generateRandomUUID() {
  var uuid = const Uuid();
  return uuid.v4();
}
