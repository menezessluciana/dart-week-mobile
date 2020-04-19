import 'package:dart_week_mobile/app/components/controleja_button.dart';
import 'package:dart_week_mobile/app/components/controleja_text_form_field.dart';
import 'package:dart_week_mobile/app/core/store_state.dart';
import 'package:dart_week_mobile/app/mixins/loader_mixin.dart';
import 'package:dart_week_mobile/app/utils/size_utils.dart';
import 'package:dart_week_mobile/app/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'cadastro_controller.dart';

class CadastroPage extends StatefulWidget {
  final String title;
  const CadastroPage({Key key, this.title = "Cadastro"}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState
    extends ModularState<CadastroPage, CadastroController> with LoaderMixin {
  //use 'controller' variable to access controller
  List<ReactionDisposer> _disposer;
  AppBar appBar = AppBar(
    elevation: 0
  );

  @override
  void initState() {
    super.initState();
     _disposer ??= [
      reaction((_) => controller.state, (StoreState state) {
        if(state == StoreState.loading) {
          showLoader();
        } else if(state == StoreState.loaded){
          hideLoader();
          Get.snackbar('Login cadastrado com sucesso', 'Login cadastrado com sucesso');
          Get.offAllNamed('/login');
        }
      }),
      reaction((_) => controller.errorMessage, (String errorMessage) {
        if(errorMessage.isNotEmpty) {
          hideLoader();
          Get.snackbar('Erro ao realizar cadastro', errorMessage, backgroundColor: Colors.white);
        }
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          _makeHeader(),
          SizedBox(
            height: 30
            ),
          _makeForm(),
        ],
      ),
    );
  }
 
     //todo metodo que começa com _ é privado
    Widget _makeHeader(){
        return Container(
          color: ThemeUtils.primaryColor,
          width: SizeUtils.widthScreen,
          height: (SizeUtils.heightScreen * .5) - (SizeUtils.statusBarHeight + appBar.preferredSize.height),
          child: Stack (
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: 50,
                child: Image.asset('assets/images/logo.png'),
              ),
            ],
          )
        );
    }

    Widget _makeForm(){
       return Form (
         key: controller.globalKey,
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             children: <Widget>[
              ControleJaTextFormField(
                label: 'Login',
                onChanged: (String valor) => controller.changeLogin(valor),
                validator: (String valor) {
                  if(valor.isEmpty) {
                    return 'Login obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30
              ),
              ControleJaTextFormField(
                label: 'Senha',
                onChanged: (String valor) => controller.changeSenha(valor),
                validator: (String valor) {
                   if(valor.isEmpty) {
                    return 'Senha obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30
              ),
              ControleJaTextFormField(
                label: 'Confirma senha',
                onChanged: (String valor) => controller.changeConfirmaSenha(valor),
                validator: (String valor) {
                if (valor.isNotEmpty) {
                  if (valor != controller.senha) {
                    return 'Senha diferente de confirma senha';
                  }
                } else {
                  return 'Confirma Senha Obrigatória';
                }
                return null;
              },
              ),
              SizedBox(
                height: 30
              ),
              ControleJaButton(
                label: 'Salvar',
                 onPressed: (){
                   controller.salvarUsuario();
                 },
              ),
              SizedBox(
                height: 30
              ),
             ],
             )
         )
       );
    }
}
