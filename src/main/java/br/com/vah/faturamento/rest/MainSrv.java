package br.com.vah.faturamento.rest;

import br.com.vah.faturamento.dto.*;
import br.com.vah.faturamento.services.FaturamentoSrv;
import br.com.vah.faturamento.services.PacienteSrv;
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

  private @Inject
  FaturamentoSrv faturamentoSrv;

  private @Inject
  PacienteSrv pacienteSrv;

  @GET
  @Path("/tempoMedio")
  @Produces("application/json")
  public SetorTempoMedio tempoMedioConvenio() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SetorTempoMedio setorTempoMedio = new SetorTempoMedio();
    setorTempoMedio.setDate(sdf.format(new Date()));
    List<TempoMedio> tempos = tempoMedioSrv.recuperarTempoMedio();
    setorTempoMedio.setItems(tempos);
    return setorTempoMedio;
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

  @GET
  @Path("/faturamento")
  @Produces("application/json")
  public Faturamento faturamento() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    Faturamento faturamento = new Faturamento();
    faturamento.setDate(sdf.format(new Date()));
    List<FaturamentoGrupo> items = faturamentoSrv.recuperarPainel();
    faturamento.setItems(items);
    return faturamento;
  }

  @GET
  @Path("/pacientes")
  @Produces("application/json")
  public Paciente paciente() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    Paciente paciente = new Paciente();
    paciente.setDate(sdf.format(new Date()));
    List<PacienteItem> items = pacienteSrv.pacientes();
    paciente.setItems(items);
    return paciente;
  }
}
