import 'package:dart_week_mobile/app/core/store_state.dart';
import 'package:dart_week_mobile/app/modules/movimentacoes/components/movimentacao_item.dart';
import 'package:dart_week_mobile/app/modules/movimentacoes/components/painel_saldo/painel_saldo_widget.dart';
import 'package:dart_week_mobile/app/repositories/movimentacoes_repository.dart';
import 'package:dart_week_mobile/app/repositories/usuario_repository.dart';
import 'package:dart_week_mobile/app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'movimentacoes_controller.dart';

class MovimentacoesPage extends StatefulWidget {
  final String title;
  const MovimentacoesPage({Key key, this.title = "Movimentacoes"})
      : super(key: key);

  @override
  _MovimentacoesPageState createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState
    extends ModularState<MovimentacoesPage, MovimentacoesController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    super.initState();
    //tem que dar o bind no repository para usar algum metodo dele no controller
    controller.buscarMovimentacoes();
    
    
  }
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: Icon(Icons.add),
          itemBuilder: (_) {
            return [
              PopupMenuItem<String>(
                value: 'Receita',
                child: Text('Receita'),
              ),
               PopupMenuItem<String>(
                value: 'despesa',
                child: Text('Despesa'),
              ),
            ];
          },
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
             Modular.get<UsuarioRepository>().logout();
             Get.offAllNamed('/');
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: SizeUtils.heightScreen,
        //quando preciso componentes que sobrepoem outros, usa stack
        child: Stack(
          children: <Widget>[
            Observer(
              builder: (_) {
                  switch(controller.movimentacoesState){
                    case StoreState.initial:
                    case StoreState.loading: 
                      return Container(
                        height: SizeUtils.heightScreen,
                        alignment: Alignment.topCenter,
                        child: Container(
                              margin: EdgeInsets.only(top: 30),
                              child: CircularProgressIndicator(),
                        ),
                      );
                    case StoreState.loaded: 
                      return _makeContent();
                    case StoreState.error:
                      Get.snackbar('Erro ao buscar dados',controller.errorMessage);
                      return Container();
                }
              }
            ),
            _makeContent(),
            PainelSaldoWidget(appBarHeight: appBar.preferredSize.height),      
          ],
        ),
      ),
    );
  }

  Widget _makeContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child:  //esse tipo de listview insere a linha para separar os itens
            ListView.separated(
              //quando nao vou utilizar o contexto, passo como _
              itemBuilder: (_, index) => MovimentacaoItem(item: controller.movimentacoes[index]),
              separatorBuilder: (_, index) => Divider(color: Colors.black),
              itemCount: controller.movimentacoes?.length ?? 0,
              ),
        ),
        SizedBox(height: SizeUtils.heightScreen * 0.08),
      ],
    );
  }
}
            
