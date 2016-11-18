package br.com.vah.faturamento.dto;

import java.util.List;

/**
 * Created by Jairoportela on 17/11/2016.
 */
public class SemRemessa {

  private String version;
  private String date;
  private List<SemRemessaItem> items;

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

  public List<SemRemessaItem> getItems() {
    return items;
  }

  public void setItems(List<SemRemessaItem> items) {
    this.items = items;
  }

}
