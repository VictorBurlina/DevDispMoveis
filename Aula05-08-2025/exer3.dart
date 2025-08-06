// 3 - Adicione o método lancaNota() para adicionar uma nota assim: nome.lancaNota(6.3);
void main() {
  Aluno aluno1 = Aluno(
    "Fulano de Tal",
    "123456"
  );
  
  aluno1.lancaNota(6.3);
  
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