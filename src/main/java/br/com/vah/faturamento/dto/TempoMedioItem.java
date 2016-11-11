package br.com.vah.faturamento.dto;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Jairoportela on 09/11/2016.
 */
public class TempoMedioItem implements Serializable {

  private String version = "0.0.1";
  private String date;
  private List<TempoMedio> indices;

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

  public List<TempoMedio> getIndices() {
    return indices;
  }

  public void setIndices(List<TempoMedio> indices) {
    this.indices = indices;
  }
}
