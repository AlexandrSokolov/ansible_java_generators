package com.brandmaker.cs.disney.activ_chargeback.auth;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.StringJoiner;

//TODO play with DTO without annotations
@JsonAutoDetect(getterVisibility = JsonAutoDetect.Visibility.NONE)
public class JwtTokenDto {

  String access_token;

  public JwtTokenDto() {
  }

  @JsonCreator
  public JwtTokenDto(@JsonProperty(value = "access_token", required = true) String access_token) {
    this.access_token = access_token;
  }

  public String accessToken() {
    return access_token;
  }

  public void accessToken(String access_token) {
    this.access_token = access_token;
  }

  public String getAccess_token() {
    return access_token;
  }

  public void setAccess_token(String access_token) {
    this.access_token = access_token;
  }

  @Override
  public String toString() {
    return new StringJoiner(", ", JwtTokenDto.class.getSimpleName() + "[", "]")
      .add("access_token='" + access_token + "'")
      .toString();
  }
}
