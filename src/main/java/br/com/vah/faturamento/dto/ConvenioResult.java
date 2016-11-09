package br.com.vah.faturamento.dto;

import java.io.Serializable;

/**
 * Created by Jairoportela on 09/11/2016.
 */
public class ConvenioResult implements Serializable {

  private String version = "0.0.1";
  private String date;

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
}
