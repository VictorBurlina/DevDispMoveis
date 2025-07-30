void main() {
  // Ex: 2 - Encontre na biblioteca dart:core a classe DateTime, veja como fazer para obter o número do mês atual. Altere o programa de praticando E para usar o valor do mês atual na variável atual.
  
  int informado = 8;
  int mesAtual = DateTime.now().month;
  
  if(mesAtual > informado){
    print('$mesAtual é maior que $informado');
  }else if(mesAtual == informado){
    print('$mesAtual é igual ao $informado');
  }else{
    print('$mesAtual é menor que $informado');
  }
} 