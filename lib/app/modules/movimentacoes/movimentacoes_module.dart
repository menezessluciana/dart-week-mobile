import 'package:dart_week_mobile/app/modules/login/login_module.dart';
import 'package:dart_week_mobile/app/modules/movimentacoes/components/painel_saldo/painel_saldo_controller.dart';
import 'package:dart_week_mobile/app/modules/movimentacoes/movimentacoes_controller.dart';
import 'package:dart_week_mobile/app/repositories/movimentacoes_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dart_week_mobile/app/modules/movimentacoes/movimentacoes_page.dart';

class MovimentacoesModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PainelSaldoController()),
        Bind((i) => MovimentacoesRepository()),
        Bind((i) => MovimentacoesController(
          i.get<MovimentacoesRepository>(),
          i.get<PainelSaldoController>())),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => MovimentacoesPage()),
      ];

  static Inject get to => Inject<MovimentacoesModule>.of();
}
