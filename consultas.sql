SELECT C.NM_CONVENIO, COUNT(*) AS QTD_ABERTAS FROM USRDBVAH.TB_GUIABI_GUIA G
  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO
  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO
WHERE DT_RESPOSTA_CONVENIO IS NULL
  AND DT_GUIA > TO_DATE('01-08-2016', 'DD-MM-YYYY')
GROUP BY C.NM_CONVENIO
ORDER BY QTD_ABERTAS DESC;

SELECT C.NM_CONVENIO, CAST(AVG(G.DT_RESPOSTA_CONVENIO - G.DT_GUIA) AS INT) AS DIAS_RESPOSTA
FROM USRDBVAH.TB_GUIABI_GUIA G
  LEFT JOIN DBAMV.TB_ATENDIME ATD ON ATD.CD_ATENDIMENTO = G.CD_ATENDIMENTO
  LEFT JOIN DBAMV.CONVENIO C ON C.CD_CONVENIO = ATD.CD_CONVENIO
WHERE DT_RESPOSTA_CONVENIO IS NOT NULL
  AND DT_GUIA > TO_DATE('01-08-2016', 'DD-MM-YYYY')
  AND DT_RESPOSTA_CONVENIO > DT_GUIA
GROUP BY C.NM_CONVENIO
ORDER BY DIAS_RESPOSTA DESC;

SELECT * FROM USRDBVAH.TB_GUIABI_GUIA G WHERE DT_GUIA < TO_DATE('01-01-2000', 'DD-MM-YYYY');

SELECT * FROM USRDBVAH.TB_GUIABI_GUIA G WHERE DT_RESPOSTA_CONVENIO < DT_GUIA;