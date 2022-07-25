ARG MSVC_NAME=msvc-usuarios

FROM openjdk:17.0-jdk-slim-buster as builder
ARG MSVC_NAME
WORKDIR /app/$MSVC_NAME

COPY ./pom.xml /app
COPY ./$MSVC_NAME/.mvn ./.mvn
COPY ./$MSVC_NAME/mvnw .
COPY ./$MSVC_NAME/pom.xml .

RUN ./mvnw clean package -Dmaven.test.skip -Dmaven.main.skip -Dspring-boot.repackage.skip && rm -r ./target/
#otra opcion que hace lo mismo:
#RUN ./mvnw dependency:go-offline
COPY ./$MSVC_NAME/src ./src

RUN ./mvnw clean package -DskipTests

FROM openjdk:17.0-jdk-slim-buster

ARG MSVC_NAME
WORKDIR /app
RUN mkdir ./logs
ARG TARGET_FOLDER=/app/$MSVC_NAME/target
COPY --from=builder $TARGET_FOLDER/msvc-usuarios-0.0.1-SNAPSHOT.jar .
ARG PORT_APP=8001
ENV PORT $PORT_APP
EXPOSE $PORT
#ENTRYPOINT ["java", "-jar", "msvc-usuarios-0.0.1-SNAPSHOT.jar"]
#entrypoint ejecuta un comando una ves arrancado el contenedor y es inmutable, no permite que se ejecuten comandos externos al contenedor
#sin embargo con CMD si ejecutamos un comando interactivo va a sobreescribir lo que esta en llaves cuadradas
#CMD ["java", "-jar", "msvc-usuarios-0.0.1-SNAPSHOT.jar"]
CMD sleep 20 && java -jar msvc-usuarios-0.0.1-SNAPSHOT.jar