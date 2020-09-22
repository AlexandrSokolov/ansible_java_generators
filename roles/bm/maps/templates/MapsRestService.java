package com.brandmaker.cs.disney.activ_chargeback.app;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import com.bm.maps.NodeDTO;
import com.brandmaker.cs.disney.activ_chargeback.auth.MmsJwtAuthProvider;
import com.brandmaker.cs.disney.activ_chargeback.commons.jax.rs.client.JaxRsProxyConfig;
import com.brandmaker.cs.disney.activ_chargeback.config.Configuration;

public class MapsRestService {

  @Inject
  Configuration configuration;

  JaxRsProxyConfig jaxRsProxyConfig;

  @PostConstruct
  void init() {
    jaxRsProxyConfig = JaxRsProxyConfig
      .builder()
      .withDomain(configuration.domain())
      .withClazz4Logging(ApplicationService.class)
      .withCustomAuthFilter(
        MmsJwtAuthProvider.jwtViaBasic(
          configuration.domain(),
          configuration.login(),
          configuration.password()))
      .build();

    NodeDTO nodeDTO = null;
  }
}
