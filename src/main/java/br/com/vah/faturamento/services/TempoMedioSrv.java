package br.com.vah.faturamento.services;

import br.com.vah.faturamento.dto.SetorTempoMedio;
import br.com.vah.faturamento.dto.TempoMedio;
import br.com.vah.faturamento.dto.TempoMedioItem;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import javax.ejb.Stateless;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Jairoportela on 10/11/2016.
 */
@Stateless
public class TempoMedioSrv extends AbstractSrv {

  public List<TempoMedio> recuperarTempoMedio() {
    String sqlQtdAbertas =
        "SELECT C.NM_CONVENIO, COUNT(*) AS QTD, S.NM_SETOR FROM USRDBVAH.TB_GUIABI_GUIA G" +
        "  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO" +
        "  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO" +
        "  LEFT JOIN DBAMV.SETOR S ON S.CD_SETOR = G.CD_SETOR " +
        "  WHERE DT_RESPOSTA_CONVENIO IS NULL" +
        "  AND DT_GUIA > to_date('01-08-2016', 'DD-MM-YYYY')" +
        "  GROUP BY C.NM_CONVENIO, S.NM_SETOR" +
        "  ORDER BY S.NM_SETOR ASC, QTD DESC";

    String sqlMediaDias =
        "SELECT C.NM_CONVENIO, CAST(AVG(G.DT_RESPOSTA_CONVENIO - G.DT_GUIA) AS INT) AS DIAS_RESPOSTA, S.NM_SETOR" +
            " FROM USRDBVAH.TB_GUIABI_GUIA G" +
            "  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO" +
            "  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO" +
            "  LEFT JOIN DBAMV.SETOR S ON S.CD_SETOR = G.CD_SETOR" +
            " WHERE DT_RESPOSTA_CONVENIO IS NOT NULL" +
            "  AND DT_GUIA > TO_DATE('01-08-2016', 'DD-MM-YYYY')" +
            "  AND DT_RESPOSTA_CONVENIO > DT_GUIA" +
            " GROUP BY C.NM_CONVENIO, S.NM_SETOR" +
            " ORDER BY S.NM_SETOR ASC, DIAS_RESPOSTA DESC";

    Session session = getSession();
    SQLQuery query = session.createSQLQuery(sqlQtdAbertas);

    List<Object[]> result = (List<Object[]>) query.list();

    Map<String, TempoMedio> tempos = new HashMap<>();
    Map<String, Map<String, TempoMedioItem>> convenios = new HashMap<>();

    List<TempoMedio> list = new ArrayList<>();

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      Integer qtdAbertas = ((BigDecimal) obj[1]).intValue();
      String setor = ((String) obj[2]);
      TempoMedio tempo = tempos.get(setor);
      if (tempo == null) {
        tempo = new TempoMedio();
        tempo.setTitle(setor);
        tempos.put(setor, tempo);
        convenios.put(setor, new HashMap<>());
        list.add(tempo);
      }
      TempoMedioItem item = new TempoMedioItem();
      item.setNome(convenio);
      item.setQuantidade(qtdAbertas);
      tempo.getItems().add(item);
      convenios.get(setor).put(convenio, item);
    }

    query = session.createSQLQuery(sqlMediaDias);

    result = query.list();

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      Integer media = ((BigDecimal) obj[1]).intValue();
      String setor = ((String) obj[2]);
      TempoMedio tempo = tempos.get(setor);
      if (tempo == null) {
        tempo = new TempoMedio();
        tempo.setTitle(setor);
        tempos.put(setor, tempo);
        convenios.put(setor, new HashMap<>());
      }
      TempoMedioItem item = convenios.get(setor).get(convenio);
      if (item == null) {
        item = new TempoMedioItem();
        item.setNome(convenio);
        item.setMedia(media);
        item.setQuantidade(0);
        tempo.getItems().add(item);
        convenios.get(setor).put(convenio, item);
      } else {
        item.setMedia(media);
      }
    }

    return list;
  }

}
