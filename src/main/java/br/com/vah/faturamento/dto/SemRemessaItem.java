package br.com.vah.faturamento.dto;

import java.math.BigDecimal;

/**
 * Created by Jairoportela on 17/11/2016.
 */
public class SemRemessaItem {

  private String convenio;
  private String status;
  private Integer quantidade;
  private Integer mediaDias;
  private String mediaValor;

  public String getConvenio() {
    return convenio;
  }

  public void setConvenio(String convenio) {
    this.convenio = convenio;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Integer getQuantidade() {
    return quantidade;
  }

  public void setQuantidade(Integer quantidade) {
    this.quantidade = quantidade;
  }

  public Integer getMediaDias() {
    return mediaDias;
  }

  public void setMediaDias(Integer mediaDias) {
    this.mediaDias = mediaDias;
  }

  public String getMediaValor() {
    return mediaValor;
  }

  public void setMediaValor(String mediaValor) {
    this.mediaValor = mediaValor;
  }
}
