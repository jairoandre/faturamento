package br.com.vah.faturamento.dto;

import java.util.List;

/**
 * Created by Jairoportela on 05/12/2016.
 */
public class Faturamento {

  private String version = "0.0.1";
  private String date;
  private List<FaturamentoGrupo> items;

  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }

  public List<FaturamentoGrupo> getItems() {
    return items;
  }

  public void setItems(List<FaturamentoGrupo> items) {
    this.items = items;
  }
}
