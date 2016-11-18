package br.com.vah.faturamento.dto;

/**
 * Created by Jairoportela on 10/11/2016.
 */
public class TempoMedioItem {

  private String nome;
  private Integer quantidade;
  private Integer media;

  public String getNome() {
    return nome;
  }

  public void setNome(String nome) {
    this.nome = nome;
  }

  public Integer getQuantidade() {
    return quantidade;
  }

  public void setQuantidade(Integer quantidade) {
    this.quantidade = quantidade;
  }

  public Integer getMedia() {
    return media;
  }

  public void setMedia(Integer media) {
    this.media = media;
  }
}
