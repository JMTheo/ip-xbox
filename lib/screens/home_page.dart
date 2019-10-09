import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_ip/get_ip.dart';
import 'package:ip_xbox/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

_getPublicIP() async {
  try {
    Response response = await Dio().get('https://api.ipify.org');
    return response;
  } catch (e) {
    print(e);
  }
}

_getWifiIP() async {
  String ipRoteador = '';
  try {
    String ipAddress = await GetIp.ipAddress;
    print(ipAddress); //192.168.232.2
    ipRoteador = ipAddress.substring(0, 11) + '1';
    return ipRoteador;
  } catch (e) {
    print(e);
  }
}

class _HomeState extends State<Home> {
  int currentStep = 0;
  List<Step> mySteps = [
    Step(
        // Title of the Step
        title: Text('Verificando o Ip publico'),
        // Content, it can be any widget here. Using basic Text for this example
        subtitle: Text('Aguarde um pouco ...'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Este é o IP público da rede, guarde esse endereçamento, a ultima cadeia de ip será a que vc precisara por como ip do xbox no caso xx.xxx.xxx.YYY, sendo o YYY do xbox'),
            SizedBoxEspaco(),
            FutureBuilder<dynamic>(
              future: _getPublicIP(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Não foi possível buscar o ip');
                  case ConnectionState.active:
                    return Text('Buscando o IP publico');
                  case ConnectionState.waiting:
                    return Text('Espere');
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    return Text('IP: ${snapshot.data.toString()}');
                }
              },
            ),
          ],
        ),
        isActive: true),
    Step(
        title: Text("Procurando o ip do roteador"),
        content: Column(
          children: <Widget>[
            Text(
                'Escreva o ip abaixo no navegador para poder acessar o menu de configuração de roteador'),
            SizedBoxEspaco(),
            FutureBuilder<dynamic>(
              future: _getWifiIP(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Não foi possível pegar o ip do roteador');
                  case ConnectionState.active:
                    return Text('Procurando o ip ....');
                  case ConnectionState.waiting:
                    return Text('Espere ...');
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Erro: ${snapshot.error}');
                    return Text('Ip do roteador: ${snapshot.data.toString()}');
                }
              },
            )
          ],
        ),
        // You can change the style of the step icon i.e number, editing, etc.
        state: StepState.indexed,
        isActive: true),
    Step(
      title: Text("Acessando o Roteador"),
      content: Column(
        children: <Widget>[
          Text(
              'Entre com o login/senha sem aspas \"admin\" e a senha \"theo121299\"'),
          SizedBoxEspaco(),
          Text(
              'Vá em configurações avançadas, no menu CONFIGURAÇÕES>LAN substitua o endereço de IP pelo o ip do passo 1 e clique em salvar'),
          SizedBoxEspaco(),
          Text(
              'LEMBRE-SE DE ALTERAR A ULTIMA CADEIA YYY PARA 1 (cuidado pois pode fuder a rede inteira)',
              style: kWarningLabel),
          SizedBoxEspaco(),
          Text(
              'Espere reiniciar, o Chrome geralmente já te redireciona após o reboot.'),
          SizedBoxEspaco(),
          Text(
              'Agora vá para DHCP>Lista de Clientes, adicione o YYY do ip publico no endereço de IP e adicione o mac address com fio do xbox (BC:83:85:86:71:61)'),
          SizedBoxEspaco(),
          Text('Clique em adicionar e dps Salvar'),
        ],
      ),
      isActive: true,
    ),
    Step(
      title: Text('Configuração no XBOX'),
      content: Column(
        children: <Widget>[
          Text(
              'Vá para as configurações de rede, opções avançadas, configurações de ip, selecione o modo Automático e aperte B para testar a conexão,'),
          SizedBoxEspaco(),
          Text(
              'Se a NAT estiver aberta é só jogat J O T A, caso não esteja vai em conf. de rede > opções de rede > endereço MAC alternativo > clique em Limpar/automatico e espere reiniciar')
        ],
      ),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mudando o IP do Xbox'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stepper(
                steps: mySteps,
                type: StepperType.vertical,
                currentStep: this.currentStep,
                onStepTapped: (step) {
                  // On hitting step itself, change the state and jump to that step
                  setState(() {
                    // update the variable handling the current step value
                    // jump to the tapped step
                    currentStep = step;
                  });
                  // Log function call
                  print("onStepTapped : " + step.toString());
                },
                onStepCancel: () {
                  // On hitting cancel button, change the state
                  setState(() {
                    // update the variable handling the current step value
                    // going back one step i.e subtracting 1, until its 0
                    if (currentStep > 0) {
                      currentStep = currentStep - 1;
                    } else {
                      currentStep = 0;
                    }
                  });
                  // Log function call
                  print("onStepCancel : " + currentStep.toString());
                },
                onStepContinue: () {
                  setState(() {
                    // update the variable handling the current step value
                    // going back one step i.e adding 1, until its the length of the step
                    if (currentStep < mySteps.length - 1) {
                      currentStep = currentStep + 1;
                    } else {
                      currentStep = 0;
                    }
                  });
                  // Log function call
                  print("onStepContinue : " + currentStep.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizedBoxEspaco extends StatelessWidget {
  const SizedBoxEspaco({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
    );
  }
}
