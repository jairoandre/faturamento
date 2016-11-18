package br.com.vah.faturamento.services;

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

  public List<TempoMedioItem> recuperarTempoMedio() {
    String sqlQtdAbertas =
        "SELECT C.NM_CONVENIO, COUNT(*) AS QTD FROM USRDBVAH.TB_GUIABI_GUIA G" +
        "  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO" +
        "  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO" +
        "  WHERE DT_RESPOSTA_CONVENIO IS NULL" +
        "  AND DT_GUIA > to_date('01-08-2016', 'DD-MM-YYYY')" +
        "  GROUP BY C.NM_CONVENIO" +
        "  ORDER BY QTD DESC";

    String sqlMediaDias =
        "SELECT C.NM_CONVENIO, CAST(AVG(G.DT_RESPOSTA_CONVENIO - G.DT_GUIA) AS INT) AS DIAS_RESPOSTA" +
            " FROM USRDBVAH.TB_GUIABI_GUIA G" +
            "  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO" +
            "  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO" +
            " WHERE DT_RESPOSTA_CONVENIO IS NOT NULL" +
            "  AND DT_GUIA > TO_DATE('01-08-2016', 'DD-MM-YYYY')" +
            "  AND DT_RESPOSTA_CONVENIO > DT_GUIA" +
            " GROUP BY C.NM_CONVENIO" +
            " ORDER BY DIAS_RESPOSTA DESC";

    Session session = getSession();
    SQLQuery query = session.createSQLQuery(sqlQtdAbertas);

    List<Object[]> result = (List<Object[]>) query.list();

    List<TempoMedioItem> list = new ArrayList<>();
    Map<String, TempoMedioItem> map = new HashMap<>();

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      Integer qtdAbertas = ((BigDecimal) obj[1]).intValue();
      TempoMedioItem tempoMedio = new TempoMedioItem();
      tempoMedio.setNome(convenio);
      tempoMedio.setQuantidade(qtdAbertas);
      list.add(tempoMedio);
      map.put(convenio, tempoMedio);
    }

    query = session.createSQLQuery(sqlMediaDias);

    result = query.list();

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      Integer media = ((BigDecimal) obj[1]).intValue();
      TempoMedioItem tempoMedio = map.get(convenio);
      if (tempoMedio == null) {
        tempoMedio = new TempoMedioItem();
        tempoMedio.setNome(convenio);
        tempoMedio.setMedia(media);
        tempoMedio.setQuantidade(-1);
        list.add(tempoMedio);
        map.put(convenio, tempoMedio);
      } else {
        tempoMedio.setMedia(media);
      }
    }

    return list;
  }

}
