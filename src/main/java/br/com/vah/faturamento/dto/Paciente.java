package br.com.vah.faturamento.dto;

import java.util.List;

/**
 * Created by Jairoportela on 13/12/2016.
 */
public class Paciente {
  private String version = "0.0.1";
  private String date;
  private List<PacienteItem> items;

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

  public List<PacienteItem> getItems() {
    return items;
  }

  public void setItems(List<PacienteItem> items) {
    this.items = items;
  }
}
