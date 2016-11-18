package br.com.vah.faturamento.rest;

import br.com.vah.faturamento.dto.SemRemessa;
import br.com.vah.faturamento.dto.SemRemessaItem;
import br.com.vah.faturamento.dto.TempoMedioItem;
import br.com.vah.faturamento.dto.TempoMedio;
import br.com.vah.faturamento.services.SemRemessaSrv;
import br.com.vah.faturamento.services.TempoMedioSrv;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by Jairoportela on 09/11/2016.
 */
@Path("/api")
public class MainSrv {

  private @Inject
  TempoMedioSrv tempoMedioSrv;

  private @Inject
  SemRemessaSrv semRemessaSrv;

  @GET
  @Path("/tempoMedio")
  @Produces("application/json")
  public TempoMedio tempoMedioConvenio() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    TempoMedio convenio = new TempoMedio();
    convenio.setDate(sdf.format(new Date()));
    List<TempoMedioItem> items = tempoMedioSrv.recuperarTempoMedio();
    convenio.setItems(items);
    return convenio;
  }

  @GET
  @Path("/semRemessa")
  @Produces("application/json")
  public SemRemessa semRemessa() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SemRemessa semRemessa = new SemRemessa();
    semRemessa.setDate(sdf.format(new Date()));
    List<SemRemessaItem> items = semRemessaSrv.recuperarContasSemRemessa();
    semRemessa.setItems(items);
    return semRemessa;
  }
}
