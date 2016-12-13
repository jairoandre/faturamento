package br.com.vah.faturamento.services;

import br.com.vah.faturamento.dto.PacienteItem;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import javax.ejb.Stateless;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Created by Jairoportela on 13/12/2016.
 */
@Stateless
public class PacienteSrv extends AbstractSrv {

  public List<PacienteItem> pacientes() {

    String sql =
        "SELECT * " +
            "FROM ( " +
            "  SELECT " +
            "    P.NM_PACIENTE, " +
            "    A.CD_ATENDIMENTO, " +
            "    A.CD_REG_FAT, " +
            "    C.NM_CONVENIO, " +
            "    TRUNC(SYSDATE - A.DT_FINAL) QTDE_DIAS, " +
            "    A.VL_TOTAL_CONTA " +
            "  FROM DBAMV.REG_FAT A " +
            "    LEFT JOIN DBAMV.CONVENIO C " +
            "      ON A.CD_CONVENIO = C.CD_CONVENIO " +
            "    LEFT JOIN DBAMV.TB_ATENDIME D " +
            "      ON A.CD_ATENDIMENTO = D.CD_ATENDIMENTO " +
            "    LEFT JOIN DBAMV.PACIENTE P " +
            "      ON D.CD_PACIENTE = P.CD_PACIENTE " +
            "    LEFT JOIN DBAMV.LEITO L " +
            "      ON L.CD_LEITO = D.CD_LEITO " +
            "  WHERE A.DT_FINAL IS NOT NULL " +
            "        AND A.CD_REMESSA IS NULL " +
            "        AND A.CD_MULTI_EMPRESA = 1 " +
            "        AND A.CD_CONVENIO <> 1 " +
            "        AND D.TP_ATENDIMENTO = 'I' " +
            "        AND A.VL_TOTAL_CONTA > 0 " +
            "        AND D.DT_ATENDIMENTO >= TO_DATE('01-01-2016', 'DD-MM-YYYY') " +
            ") " +
            "WHERE QTDE_DIAS > 60 " +
            "ORDER BY NM_CONVENIO ASC, QTDE_DIAS DESC";

    Session session = getSession();
    SQLQuery query = session.createSQLQuery(sql);

    List<Object[]> result = (List<Object[]>) query.list();

    List<PacienteItem> pacientes = new ArrayList<>();

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("pt", "BR"));

    for (Object[] obj : result) {
      PacienteItem paciente = new PacienteItem();
      paciente.setNome((String) obj[0]);
      paciente.setAtendimento(((BigDecimal) obj[1]).intValue());
      paciente.setConta(((BigDecimal) obj[2]).intValue());
      paciente.setConvenio((String) obj[3]);
      paciente.setDias(((BigDecimal) obj[4]).intValue());
      paciente.setValorTotal("R$ " + nf.format(obj[5] == null ? 0 : obj[5]));
      pacientes.add(paciente);
    }

    return pacientes;
  }
}
