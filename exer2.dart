// 2 - Em um programa crie o aluno: Aluno("Fulano de Tal", "123456");

void main() {
  Aluno aluno1 = Aluno(
    "Fulano de Tal",
    "123456"
  );
  
}

class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno(this.nome, this.matricula) : notas = [];
}