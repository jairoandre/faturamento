package br.com.vah.faturamento.rest;

import br.com.vah.faturamento.dto.ConvenioResult;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Jairoportela on 09/11/2016.
 */
@Path("/api")
public class MainSrv {

  @GET
  @Path("/tempoMedioConvenio")
  @Produces("application/json")
  public ConvenioResult tempoMedioConvenio() {
    ConvenioResult convenio = new ConvenioResult();
    convenio.setDate("09/11/2016");
    return convenio;
  }
}
