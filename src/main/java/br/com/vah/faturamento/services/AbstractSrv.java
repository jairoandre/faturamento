package br.com.vah.faturamento.services;

import org.hibernate.Session;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.io.Serializable;

/**
 * Created by Jairoportela on 10/11/2016.
 */
public abstract class AbstractSrv implements Serializable {

  @PersistenceContext
  private EntityManager em;

  public Session getSession() {
    return em.unwrap(Session.class);
  }
}
