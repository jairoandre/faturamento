package br.com.vah.faturamento.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Jairoportela on 09/11/2016.
 */
public class TempoMedio implements Serializable {

  private String title;
  private List<TempoMedioItem> items = new ArrayList<>();

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public List<TempoMedioItem> getItems() {
    return items;
  }

  public void setItems(List<TempoMedioItem> items) {
    this.items = items;
  }
}
