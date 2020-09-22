package com.brandmaker.cs.disney.activ_chargeback.auth;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * Do not use this service directly. Use ClientRequestFilter, provided by JwtClientRequestProvider.jwtAuth
 */
@Path("/rest/sso/auth")
public interface JwtAuthenticationService {

  String LOGIN = "login";
  String PASSWORD = "password";

  /**
   *  Authenticate user via basic authentication header
   *
   * @return authenticated user
   */
  @POST
  @Produces(MediaType.APPLICATION_JSON)
  JwtTokenDto authUser();

  /**
   *  Authenticate user via form submission
   *
   * @return authenticated user
   */
  @POST
  @Produces(MediaType.APPLICATION_JSON)
  @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  JwtTokenDto authUser(@FormParam(LOGIN) final String login, @FormParam(PASSWORD) final String password);


}
