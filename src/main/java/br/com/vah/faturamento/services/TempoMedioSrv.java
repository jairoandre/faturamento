package br.com.vah.faturamento.services;

import br.com.vah.faturamento.dto.ConvenioIndice;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import javax.ejb.Stateless;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Jairoportela on 10/11/2016.
 */
@Stateless
public class TempoMedioSrv extends AbstractSrv {

  public List<ConvenioIndice> recuperarIndices() {
    String sqlQtdAbertas =
        "SELECT C.NM_CONVENIO, COUNT(*) AS QTD FROM USRDBVAH.TB_GUIABI_GUIA G" +
        "  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO" +
        "  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO" +
        "  WHERE DT_RESPOSTA_CONVENIO IS NULL" +
        "  AND DT_GUIA > to_date('2016-08-01', 'YYYY-MM-DD')" +
        "  GROUP BY C.NM_CONVENIO" +
        "  ORDER BY QTD DESC";

    Session session = getSession();
    SQLQuery query = session.createSQLQuery(sqlQtdAbertas);

    List<Object[]> result = (List<Object[]>) query.list();

    List<ConvenioIndice> list = new ArrayList<>();

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      Integer qtdAbertas = ((BigDecimal) obj[1]).intValue();
      ConvenioIndice convenioIndice = new ConvenioIndice();
      convenioIndice.setNome(convenio);
      convenioIndice.setQtdAbertas(qtdAbertas);
      list.add(convenioIndice);
    }

    return list;
  }

}
