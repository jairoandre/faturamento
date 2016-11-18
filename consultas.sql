SELECT C.NM_CONVENIO, COUNT(*) AS QTD FROM USRDBVAH.TB_GUIABI_GUIA G
  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO
  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO
WHERE DT_RESPOSTA_CONVENIO IS NULL
  AND DT_GUIA > to_date('2016-08-01', 'YYYY-MM-DD')
GROUP BY C.NM_CONVENIO
ORDER BY QTD DESC;

SELECT C.NM_CONVENIO, CAST(AVG(G.DT_RESPOSTA_CONVENIO - G.DT_GUIA) AS INT) AS DIFF FROM USRDBVAH.TB_GUIABI_GUIA G
  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO
  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO
WHERE DT_RESPOSTA_CONVENIO IS NOT NULL
      AND DT_GUIA > to_date('2016-08-01', 'YYYY-MM-DD')
GROUP BY C.NM_CONVENIO
ORDER BY DIFF DESC;

/* - PAINEL COM CONTAS ABERTAS
Consultar todas as contas que estão abertas (sem remessa e com data fim) separando por convenio e por status.
Seria um painel por status com a quantidade de contas por convenio:

(dt_atual - data fim) <= 30 dias --- Amarelo.
(dt_atual - data fim) > 30 dias E (dt_atual - data fim) <= 60 --- Azul.
(dt_atual - data fim) > 60 dias - Vermelho*/

SELECT
  C.NM_CONVENIO,
  TRUNC(SYSDATE - A.DT_FINAL) QTDE_DIAS,
  (CASE
   WHEN ((SYSDATE - A.DT_FINAL) <= 30) THEN 'AMARELO'
   WHEN ((SYSDATE - A.DT_FINAL) BETWEEN 30 AND 60) THEN 'AZUL'
   WHEN ((SYSDATE - A.DT_FINAL) > 60) THEN 'VERMELHO'
   END) STATUS,
  A.VL_TOTAL_CONTA
FROM DBAMV.REG_FAT A
  JOIN DBAMV.CONVENIO C
    ON A.CD_CONVENIO = C.CD_CONVENIO
  JOIN DBAMV.TB_ATENDIME D
    ON A.CD_ATENDIMENTO = D.CD_ATENDIMENTO
WHERE A.DT_FINAL IS NOT NULL
      AND A.CD_REMESSA IS NULL
      AND A.CD_MULTI_EMPRESA = 1
      AND A.CD_CONVENIO NOT IN (1)
      AND D.TP_ATENDIMENTO = 'I'
      AND A.VL_TOTAL_CONTA > '0,00'
UNION
SELECT
  C.NM_CONVENIO,
  TRUNC(SYSDATE - D.DT_ALTA) QTDE_DIAS,
  (CASE
   WHEN ((SYSDATE - D.DT_ALTA) <= 30) THEN 'AMARELO'
   WHEN ((SYSDATE - D.DT_ALTA) BETWEEN 30 AND 60) THEN 'AZUL'
   WHEN ((SYSDATE - D.DT_ALTA) > 60) THEN 'VERMELHO'
   END) STATUS,
  T.VL_TOTAL_CONTA
FROM DBAMV.REG_AMB T
  JOIN DBAMV.ITREG_AMB B
    ON T.CD_REG_AMB = B.CD_REG_AMB
  JOIN DBAMV.CONVENIO C
    ON T.CD_CONVENIO = C.CD_CONVENIO
  JOIN DBAMV.TB_ATENDIME D
    ON B.CD_ATENDIMENTO = D.CD_ATENDIMENTO
WHERE D.DT_ALTA IS NOT NULL
      AND T.CD_REMESSA IS NULL
      AND T.CD_MULTI_EMPRESA = 1
      AND T.CD_CONVENIO NOT IN (1)
      AND D.TP_ATENDIMENTO = 'U'
      AND T.VL_TOTAL_CONTA > '0,00'
GROUP BY
  C.NM_CONVENIO,
  STATUS