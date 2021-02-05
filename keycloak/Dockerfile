FROM maven:3.3-jdk-8 AS builder

WORKDIR /usr/src/mymaven/

COPY pom.xml ./pom.xml
COPY magic-link ./magic-link
COPY themes ./themes
COPY token-validation ./token-validation

RUN mvn clean install


FROM jboss/keycloak:9.0.2 AS runner

WORKDIR /opt/jboss/keycloak/standalone/deployments/

COPY --from=builder /usr/src/mymaven/magic-link/target/magic-link.jar ./
RUN touch ./magic-link.jar.dodeploy

COPY --from=builder /usr/src/mymaven/themes/target/themes.jar ./
RUN touch ./themes.jar.dodeploy

COPY --from=builder /usr/src/mymaven/token-validation/target/token-validation.jar ./
