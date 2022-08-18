FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install wget -y
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update && \
  apt-get install -y dotnet-sdk-6.0

WORKDIR /app
ADD . /app
# ENV SERedis_EnabledCiphers=TLS_RSA_WITH_AES_128_CBC_SHA256
RUN dotnet restore
ENTRYPOINT [ "dotnet", "run", "--project",  "./TestRHELdotnet6/TestRHELdotnet6.csproj"]