// 4 - Usando o programa do exercício 2. Adicione as notas: 6.3, 5.2, 9.4.
void main() {
  Aluno aluno1 = Aluno(
    "Fulano de Tal",
    "123456"
  );
  
  aluno1.lancaNota(6.3);
  aluno1.lancaNota(5.2);
  aluno1.lancaNota(9.4);
  
}

class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno(this.nome, this.matricula) : notas = [];
  
  void lancaNota(double nota) {
    notas.add(nota);
  }
}