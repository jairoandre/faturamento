package br.com.vah.faturamento.dto;

/**
 * Created by Jairoportela on 05/12/2016.
 */
public class FaturamentoItem {

  private String convenio;
  private Integer pendentes = 0;
  private Integer daysAvg = 0;
  private Integer ge30 = 0;
  private Integer lt30 = 0;
  private Integer ge30Avg = 0;
  private Integer lt30Avg = 0;
  private String ge30ValueAvg = "R$ 0,00";
  private String lt30ValueAvg = "R$ 0,00";

  public String getConvenio() {
    return convenio;
  }

  public void setConvenio(String convenio) {
    this.convenio = convenio;
  }

  public Integer getPendentes() {
    return pendentes;
  }

  public void setPendentes(Integer pendentes) {
    this.pendentes = pendentes;
  }

  public Integer getDaysAvg() {
    return daysAvg;
  }

  public void setDaysAvg(Integer daysAvg) {
    this.daysAvg = daysAvg;
  }

  public Integer getGe30() {
    return ge30;
  }

  public void setGe30(Integer ge30) {
    this.ge30 = ge30;
  }

  public Integer getLt30() {
    return lt30;
  }

  public void setLt30(Integer lt30) {
    this.lt30 = lt30;
  }

  public Integer getGe30Avg() {
    return ge30Avg;
  }

  public void setGe30Avg(Integer ge30Avg) {
    this.ge30Avg = ge30Avg;
  }

  public Integer getLt30Avg() {
    return lt30Avg;
  }

  public void setLt30Avg(Integer lt30Avg) {
    this.lt30Avg = lt30Avg;
  }

  public String getGe30ValueAvg() {
    return ge30ValueAvg;
  }

  public void setGe30ValueAvg(String ge30ValueAvg) {
    this.ge30ValueAvg = ge30ValueAvg;
  }

  public String getLt30ValueAvg() {
    return lt30ValueAvg;
  }

  public void setLt30ValueAvg(String lt30ValueAvg) {
    this.lt30ValueAvg = lt30ValueAvg;
  }
}
