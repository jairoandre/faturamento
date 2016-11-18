package br.com.vah.faturamento.services;

import br.com.vah.faturamento.dto.SemRemessaItem;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import javax.ejb.Stateless;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Created by Jairoportela on 17/11/2016.
 */
@Stateless
public class SemRemessaSrv extends AbstractSrv {

  public List<SemRemessaItem> recuperarContasSemRemessa() {
    String sql =
        "SELECT NM_CONVENIO, STATUS, COUNT(*) QTD, TRUNC(AVG(QTDE_DIAS)) MEDIA_DIAS, " +
            "  ROUND(AVG(VL_TOTAL_CONTA), 2) MEDIA_VALOR FROM ( " +
            "SELECT " +
            "  C.NM_CONVENIO, " +
            "  TRUNC(SYSDATE - A.DT_FINAL) QTDE_DIAS, " +
            "  (CASE " +
            "   WHEN ((SYSDATE - A.DT_FINAL) <= 30) THEN 'AMARELO' " +
            "   WHEN ((SYSDATE - A.DT_FINAL) BETWEEN 30 AND 60) THEN 'AZUL' " +
            "   WHEN ((SYSDATE - A.DT_FINAL) > 60) THEN 'VERMELHO' " +
            "   END) STATUS, " +
            "  A.VL_TOTAL_CONTA " +
            "FROM DBAMV.REG_FAT A " +
            "  JOIN DBAMV.CONVENIO C " +
            "    ON A.CD_CONVENIO = C.CD_CONVENIO " +
            "  JOIN DBAMV.TB_ATENDIME D " +
            "    ON A.CD_ATENDIMENTO = D.CD_ATENDIMENTO " +
            "WHERE A.DT_FINAL IS NOT NULL " +
            "      AND A.CD_REMESSA IS NULL " +
            "      AND A.CD_MULTI_EMPRESA = 1 " +
            "      AND A.CD_CONVENIO <> 1 " +
            "      AND D.TP_ATENDIMENTO = 'I' " +
            "      AND A.VL_TOTAL_CONTA > 0 " +
            "UNION " +
            "SELECT " +
            "  C.NM_CONVENIO, " +
            "  TRUNC(SYSDATE - D.DT_ALTA) QTDE_DIAS, " +
            "  (CASE " +
            "   WHEN ((SYSDATE - D.DT_ALTA) <= 30) THEN 'AMARELO' " +
            "   WHEN ((SYSDATE - D.DT_ALTA) BETWEEN 30 AND 60) THEN 'AZUL' " +
            "   WHEN ((SYSDATE - D.DT_ALTA) > 60) THEN 'VERMELHO' " +
            "   END) STATUS, " +
            "  T.VL_TOTAL_CONTA " +
            "FROM DBAMV.REG_AMB T " +
            "  JOIN DBAMV.ITREG_AMB B " +
            "    ON T.CD_REG_AMB = B.CD_REG_AMB " +
            "  JOIN DBAMV.CONVENIO C " +
            "    ON T.CD_CONVENIO = C.CD_CONVENIO " +
            "  JOIN DBAMV.TB_ATENDIME D " +
            "    ON B.CD_ATENDIMENTO = D.CD_ATENDIMENTO " +
            "WHERE D.DT_ALTA IS NOT NULL " +
            "      AND T.CD_REMESSA IS NULL " +
            "      AND T.CD_MULTI_EMPRESA = 1 " +
            "      AND T.CD_CONVENIO <> 1 " +
            "      AND D.TP_ATENDIMENTO = 'U' " +
            "      AND T.VL_TOTAL_CONTA > 0 " +
            " " +
            ") GROUP BY NM_CONVENIO, STATUS";

    Session session = getSession();
    SQLQuery query = session.createSQLQuery(sql);

    List<Object[]> result = (List<Object[]>) query.list();

    List<SemRemessaItem> items = new ArrayList<>();

    NumberFormat numberFormat = new DecimalFormat("R$ #,##0.00");

    for (Object[] obj : result) {
      String convenio = (String) obj[0];
      String status = (String) obj[1];
      Integer quantidade = ((BigDecimal) obj[2]).intValue();
      Integer mediaDias = ((BigDecimal) obj[3]).intValue();
      BigDecimal mediaValor = (BigDecimal) obj[4];
      SemRemessaItem item = new SemRemessaItem();
      item.setConvenio(convenio);
      item.setStatus(status);
      item.setQuantidade(quantidade);
      item.setMediaDias(mediaDias);
      item.setMediaValor(numberFormat.format(mediaValor));
      items.add(item);
    }

    Collections.sort(items, new Comparator<SemRemessaItem>() {
      @Override
      public int compare(SemRemessaItem o1, SemRemessaItem o2) {
        return -o1.getQuantidade().compareTo(o2.getQuantidade());
      }
    });

    return items;
  }
}
