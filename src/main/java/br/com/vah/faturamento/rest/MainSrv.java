package br.com.vah.faturamento.rest;

import br.com.vah.faturamento.dto.ConvenioIndice;
import br.com.vah.faturamento.dto.ConvenioResult;
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

  @GET
  @Path("/tempoMedioConvenio")
  @Produces("application/json")
  public ConvenioResult tempoMedioConvenio() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    ConvenioResult convenio = new ConvenioResult();
    convenio.setDate(sdf.format(new Date()));
    List<ConvenioIndice> indices = tempoMedioSrv.recuperarIndices();
    convenio.setIndices(indices);
    return convenio;
  }
}
