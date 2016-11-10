package br.com.vah.faturamento.dto;

/**
 * Created by Jairoportela on 10/11/2016.
 */
public class ConvenioIndice {

  private String nome;
  private Integer qtdAbertas;
  private Integer mediaDiasAberta;

  public String getNome() {
    return nome;
  }

  public void setNome(String nome) {
    this.nome = nome;
  }

  public Integer getQtdAbertas() {
    return qtdAbertas;
  }

  public void setQtdAbertas(Integer qtdAbertas) {
    this.qtdAbertas = qtdAbertas;
  }

  public Integer getMediaDiasAberta() {
    return mediaDiasAberta;
  }

  public void setMediaDiasAberta(Integer mediaDiasAberta) {
    this.mediaDiasAberta = mediaDiasAberta;
  }
}
