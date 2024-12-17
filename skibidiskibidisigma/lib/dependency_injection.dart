import 'package:skibidiskibidisigma/app/modules/connection/bindings/connection_binding.dart';
import 'package:skibidiskibidisigma/app/modules/review/bindings/review_binding.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
  }
}