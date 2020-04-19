import 'package:dart_week_mobile/app/core/store_state.dart';
import 'package:dart_week_mobile/app/repositories/usuario_repository.dart';
import 'package:dart_week_mobile/app/utils/store_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'cadastro_controller.g.dart';

class CadastroController = _CadastroControllerBase with _$CadastroController;

abstract class _CadastroControllerBase with Store {
   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final UsuarioRepository usuarioRepository;
  //São passiveis de alteração
  @observable
  String login;

  @observable
  String senha;

  @observable
  String confirmaSenha;

  _CadastroControllerBase(this.usuarioRepository);

  @action 
  changeLogin(String loginValue) => login = loginValue;

  @action 
  changeSenha(String senhaValue) => senha = senhaValue;

   @action 
  changeConfirmaSenha(String confirmaSenhaValue) => confirmaSenha = confirmaSenhaValue;

  //Requisição assincrona observable
  @observable
  ObservableFuture _cadastraLoginFuture;

  //Toda vez que o observable _cadastroFuture alterar o valor, executa o statusCheck
  @computed
  StoreState get state => StoreUtils.statusCheck(_cadastraLoginFuture);

  @observable
  String errorMessage;

  Future<void> salvarUsuario() async {
    if(globalKey.currentState.validate()){
      errorMessage = '';
      try{
        _cadastraLoginFuture = ObservableFuture(usuarioRepository.cadastrarUsuario(login, senha));
        await _cadastraLoginFuture;
      }catch(e){
        print(e);
        errorMessage='Erro ao cadastrar usuário';
      }
    }
  }

}
