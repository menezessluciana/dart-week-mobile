import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'painel_saldo_controller.g.dart';

class PainelSaldoController = _PainelSaldoControllerBase
    with _$PainelSaldoController;

abstract class _PainelSaldoControllerBase with Store {
  
  @observable
  DateTime data = DateTime.now();


  @action
  nextMonth() {
    print('nextMonth');
    data = DateTime(data.year, data.month +1, 1);
    print(data);
  }
  @action
  previousMonth() {
     print('previousMonth');
    data = DateTime(data.year, data.month -1, 1);
  }

  @computed
  String get anoMes => DateFormat('yyyyMM').format(data);

}
