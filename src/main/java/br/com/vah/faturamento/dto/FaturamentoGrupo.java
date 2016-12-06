package br.com.vah.faturamento.dto;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Jairoportela on 05/12/2016.
 */
public class FaturamentoGrupo {

  private String title;
  private List<FaturamentoItem> items = new ArrayList<>();

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public List<FaturamentoItem> getItems() {
    return items;
  }

  public void setItems(List<FaturamentoItem> items) {
    this.items = items;
  }
}
