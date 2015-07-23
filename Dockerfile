FROM java:openjdk-8-jdk

COPY initializr-service/start.jar /

CMD java -jar start.jar