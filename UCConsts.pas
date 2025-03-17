unit UCConsts;

interface

Const
  // new consts version 2 a 5 =========================================
  // Form Select Controls (design-time)
  Const_Contr_TitleLabel = 'Seleção de Componentes do Form. :';
  Const_Contr_GroupLabel = 'Grupo :';
  Const_Contr_CompDispLabel = 'Componentes Disponíveis :';
  Const_Contr_CompSelLabel = 'Componentes Selecionados :';
  Const_Contr_BtOK = '&OK';
  Const_Contr_BTCancel = '&Cancelar';
  Const_Contr_DescCol = 'Descrição';

  Const_Contr_BtSellAllHint = 'Select All'; //added by fduenas
  Const_Contr_BtSelHint = 'Select'; //added by fduenas
  Const_Contr_BtUnSelHint = 'Unselect'; //added by fduenas
  Const_Contr_BtUnSelAllHint = 'Unselect All'; //added by fduenas
  //===================================================================


  // group property Settins.AppMsgsForm
  Const_Msgs_BtNew         = '&Nova Mensagem';
  Const_Msgs_BtReplay      = '&Responder';
  Const_Msgs_BtForward     = 'E&ncaminhar';
  Const_Msgs_BtDelete      = '&Excluir';
  Const_Msgs_BtClose       = '&Close'; //added by fduenas
  Const_Msgs_WindowCaption = 'Mensagens do Sistema';
  Const_Msgs_ColFrom       = 'Remetente';
  Const_Msgs_ColSubject    = 'Assunto';
  Const_Msgs_ColDate       = 'Data';
  Const_Msgs_PromptDelete  = 'Confirma excluir as mensagens selecionadas ?';
  Const_Msgs_PromptDelete_WindowCaption  = 'Delete messages'; //added by fduenas
  Const_Msgs_NoMessagesSelected = '!No Messages selected¡'; //added by fduenas
  Const_Msgs_NoMessagesSelected_WindowCaption = 'Information'; //added by fduenas


  // group property Settins.AppMsgsRec
  Const_MsgRec_BtClose       = '&Fechar';
  Const_MsgRec_WindowCaption = 'Mensagem';
  Const_MsgRec_Title         = 'Mensagem Recebida';
  Const_MsgRec_LabelFrom     = 'De :';
  Const_MsgRec_LabelDate     = 'Date';
  Const_MsgRec_LabelSubject  = 'Assunto';
  Const_MsgRec_LabelMessage  = 'Mensagem';

  // group property Settins.AppMsgsSend
  Const_MsgSend_BtSend        = '&Enviar';
  Const_MsgSend_BtCancel      = '&Cancelar';
  Const_MsgSend_WindowCaption = 'Mensagem';
  Const_MsgSend_Title         = 'Enviar Nova Mensagem';
  Const_MsgSend_GroupTo       = 'Para';
  Const_MsgSend_RadioUser     = 'Usuário :';
  Const_MsgSend_RadioAll      = 'Todos';
  Const_MsgSend_GroupMessage  = 'Mensagem';
  Const_MsgSend_LabelSubject  = 'Subject'; //added by fduenas
  Const_MsgSend_LabelMessageText = 'Message text'; //added by fduenas


  // Run errors
  MsgExceptConnection    = 'Não informado o Connection, Transaction ou Database do componente %s';
  MsgExceptTransaction   = 'Não informado o Transaction do componente %s';
  MsgExceptDatabase      = 'Não informado o Database do componente %s';
  MsgExceptUserMngMenu   = 'Informe na propriedade UsersForm.MenuItem ou UsersForm.Action o Item responsável pelo controle de usuários';
  MsgExceptUserProfile   = 'Informe na propriedade UsersProfile.MenuItem ou UsersProfile.Action o Item responsável pelo controle de Perfil de usuários';
  MsgExceptChagePassMenu = 'Informe na propriedade ChangePasswordForm.MenuItem or .Action o Item que permite ao usuário alterar sua senha';
  MsgExceptAppID         = 'Na propriedade ApplicationID informe um nome para identificar a aplicação na tabela de permissões';
  MsgExceptUsersTable    = 'Na propriedade TableUsers informe o nome da tabela que será criada para armazenar os dados dos usuários';
  MsgExceptRightsTable   = 'Na propriedade TableRights informe o nome da tabela que será criada para armazenar as permissões dos usuários';

  // group property Settings.Mensagens
  Const_Men_AutoLogonError   = 'Falha de Auto Logon!'+#13+#10+ 'Informe um usuário e senha válidos.';
  Const_Men_SenhaDesabitada  = 'Retirada senha do Login %s';
  Const_Men_SenhaAlterada    = 'Senha alterada com sucesso!';
  Const_Men_MsgInicial       = 'ATENÇÃO Login Inicial:'+#13+#10+''+#13+#10+'Usuário : :user'+#13+#10+'Senha : :password'+#13+#10+''+#13+#10+'Defina as permissões para este usuário.';
  Const_Men_MaxTentativas    = '%d Tentativas de login inválido. Por motivos de segunça o '+#13+#10+'sistema será fechado.';
  Const_Men_LoginInvalido    = 'Usuário ou Senha inválidos!';

  //group property Settings.Login
  Const_Log_BtCancelar      = '&Cancelar';
  Const_Log_BtOK            = 'OK';
  Const_Log_LabelSenha      = 'Senha : ';
  Const_Log_LabelUsuario    = 'Usuário ';
  Const_Log_WindowCaption   = 'Login';
  Const_Log_LbEsqueciSenha  = 'Esqueci a senha'; //new
  Const_Log_MsgMailSend     = 'A senha foi enviada para o seu email.'; //new

  //group property Settings.Log //new
  Const_LogC_WindowCaption   = 'Segurança';
  Const_LogC_LabelDescricao  = 'Log do Sistema';
  Const_LogC_LabelUsuario    = 'Usuário :';
  Const_LogC_LabelData       = 'Data :';
  Const_LogC_LabelNivel      = 'Nível mínimo : ';
  Const_LogC_ColunaNivel     = 'Nível';
  Const_LogC_ColunaMensagem  = 'Mensagem';
  Const_LogC_ColunaUsuario   = 'Usuário';
  Const_LogC_ColunaData      = 'Data';
  Const_LogC_BtFiltro        = '&Aplicar Filtro';
  Const_LogC_BtExcluir       = '&Excluir Log';
  Const_LogC_BtFechar        = '&Fechar';
  Const_LogC_ConfirmaExcluir = 'Confirma excluir todos os registros de log selecionados ?';
  Const_LogC_ConfirmaDelete_WindowCaption = 'Delete confirmation'; //added by fduenas
  Const_LogC_Todos = 'All';       //BGM
  Const_LogC_Low = 'Baixo';       //BGM
  Const_LogC_Normal = 'Normal';   //BGM
  Const_LogC_High = 'Alto';       //BGM
  Const_LogC_Critic = 'Crítico';  //BGM
  Const_LogC_ExcluirEfectuada = 'Deletion of system log done: '+
                                'User = "%s" | Date = %s a %s | Level <= %s'; //added by fduenas

  //group property Settings.CadastroUsuarios
  Const_Cad_WindowCaption   = 'Segurança';
  Const_Cad_LabelDescricao  = 'Cadastro de Usuários';
  Const_Cad_ColunaNome      = 'Nome';
  Const_Cad_ColunaLogin     = 'Login';
  Const_Cad_ColunaEmail     = 'Email';
  Const_Cad_BtAdicionar     = '&Adicionar';
  Const_Cad_BtAlterar       = 'A&lterar';
  Const_Cad_BtExcluir       = '&Excluir';
  Const_Cad_BtPermissoes    = 'A&cessos';
  Const_Cad_BtSenha         = '&Senha';
  Const_Cad_BtFechar        = '&Fechar';
  Const_Cad_ConfirmaExcluir = 'Confirma excluir o usuário "%s" ?';
  Const_Cad_ConfirmaDelete_WindowCaption = 'Delete user'; //added by fduenas

  //group property Settings.PerfilUsuarios
  Const_Prof_WindowCaption   = 'Segurança';
  Const_Prof_LabelDescricao  = 'Perfil de Usuários';
  Const_Prof_ColunaNome      = 'Perfil';
  Const_Prof_BtAdicionar     = '&Adicionar';
  Const_Prof_BtAlterar       = 'A&lterar';
  Const_Prof_BtExcluir       = '&Excluir';
  Const_Prof_BtPermissoes    = 'A&cessos';
  Const_Prof_BtSenha         = '&Senha';
  Const_Prof_BtFechar        = '&Fechar';
  Const_Prof_ConfirmaExcluir = 'Existem usuários com o perfil "%s". Confirma excluir?';
  Const_Prof_ConfirmaDelete_WindowCaption = 'Delete profile'; //added by fduenas

  //group property Settings.IncAltUsuario
  Const_Inc_WindowCaption     = 'Cadastro de Usuários';
  Const_Inc_LabelAdicionar    = 'Adicionar Usuário';
  Const_Inc_LabelAlterar      = 'Alterar Usuário';
  Const_Inc_LabelNome         = 'Nome : ';
  Const_Inc_LabelLogin        = 'Login : ';
  Const_Inc_LabelEmail        = 'Email : ';
  Const_Inc_LabelPerfil       = 'Perfil : ';
  Const_Inc_CheckPrivilegiado = 'Usuário privilegiado';
  Const_Inc_BtGravar          = '&Gravar';
  Const_Inc_BtCancelar        = 'Cancelar';

  //group property Settings.IncAltPerfil
  Const_PInc_WindowCaption     = 'Perfil de Usuários';
  Const_PInc_LabelAdicionar    = 'Adicionar Perfil';
  Const_PInc_LabelAlterar      = 'Alterar Perfil';
  Const_PInc_LabelNome         = 'Descrição : ';
  Const_PInc_BtGravar          = '&Gravar';
  Const_PInc_BtCancelar        = 'Cancelar';

  //group property Settings.Permissao
  Const_Perm_WindowCaption  = 'Segurança';
  Const_Perm_LabelUsuario   = 'Permissões do Usuário : ';
  Const_Perm_LabelPerfil    = 'Permissões do Perfil : ';
  Const_Perm_PageMenu       = 'Itens do Menu';
  Const_Perm_PageActions    = 'Ações';
  Const_Perm_BtLibera       = '&Liberar';
  Const_Perm_BtBloqueia     = '&Bloquear';
  Const_Perm_BtGravar       = '&Gravar';
  Const_Perm_BtCancelar     = '&Cancelar';


  //group property Settings.TrocaSenha do begin
  Const_Troc_WindowCaption   = 'Segurança';
  Const_Troc_LabelDescricao  = 'Trocar Senha';
  Const_Troc_LabelSenhaAtual = 'Senha Atual :';
  Const_Troc_LabelNovaSenha  = 'Nova Senha : ';
  Const_Troc_LabelConfirma   = 'Confirmação : ';
  Const_Troc_BtGravar        = '&Gravar';
  Const_Troc_BtCancelar      = 'Cancelar';

  //group property Settings.Mensagens.ErroTrocaSenha
  Const_ErrPass_SenhaAtualInvalida = 'Senha Atual não confere!';
  Const_ErrPass_ErroNovaSenha      = 'Os campos: Nova Senha e Confirmação devem ser iguais.';
  Const_ErrPass_NovaIgualAtual     = 'Nova senha igual a senha atual';
  Const_ErrPass_SenhaObrigatoria   = 'A Senha é obrigatória';
  Const_ErrPass_SenhaMinima        = 'A senha deve conter no mínimo %d caracteres';
  Const_ErrPass_SenhaInvalida      = 'Proibido utilizar senhas obvias!';

  //group property Settings.DefineSenha
  Const_DefPass_WindowCaption = 'Definir senha do usuário : "%s"';
  Const_DefPass_LabelSenha    = 'Senha : ';


implementation

end.

