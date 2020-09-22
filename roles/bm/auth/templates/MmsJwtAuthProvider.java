package com.brandmaker.cs.disney.activ_chargeback.auth;

import javax.ws.rs.client.ClientRequestFilter;

import com.brandmaker.cs.disney.activ_chargeback.commons.jax.rs.client.filter.AuthClientRequestFilterFactory;

public class MmsJwtAuthProvider {

  public static ClientRequestFilter jwtViaBasic(String domain, String login, String password) {
    return AuthClientRequestFilterFactory.jwtThroughBasicAuthentication(
      domain,
      login,
      password,
      JwtAuthenticationService.class,
      authService -> authService.authUser(login, password).getAccess_token(),
      MmsJwtAuthProvider.class);
  }
}
