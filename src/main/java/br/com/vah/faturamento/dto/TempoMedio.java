package br.com.vah.faturamento.dto;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Jairoportela on 09/11/2016.
 */
public class TempoMedio implements Serializable {

  private String version = "0.0.1";
  private String date;
  private List<TempoMedioItem> items;

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

  public List<TempoMedioItem> getItems() {
    return items;
  }

  public void setItems(List<TempoMedioItem> items) {
    this.items = items;
  }
}
