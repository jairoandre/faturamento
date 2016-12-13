package br.com.vah.faturamento.dto;

/**
 * CreaC:\Users\jairoportela\projects\faturamento\src\main\elm\Model\TempoMedio.elmted by Jairoportela on 13/12/2016.
 */
public class PacienteItem {

  private String nome;
  private Integer atendimento;
  private Integer conta;
  private String convenio;
  private Integer dias;
  private String valorTotal;

  public String getNome() {
    return nome;
  }

  public void setNome(String nome) {
    this.nome = nome;
  }

  public Integer getAtendimento() {
    return atendimento;
  }

  public void setAtendimento(Integer atendimento) {
    this.atendimento = atendimento;
  }

  public Integer getConta() {
    return conta;
  }

  public void setConta(Integer conta) {
    this.conta = conta;
  }

  public String getConvenio() {
    return convenio;
  }

  public void setConvenio(String convenio) {
    this.convenio = convenio;
  }

  public Integer getDias() {
    return dias;
  }

  public void setDias(Integer dias) {
    this.dias = dias;
  }

  public String getValorTotal() {
    return valorTotal;
  }

  public void setValorTotal(String valorTotal) {
    this.valorTotal = valorTotal;
  }
}
