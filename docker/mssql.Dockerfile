FROM ubuntu:20.04
ENV ACCEPT_EULA Y

USER root

RUN apt update && apt upgrade -y

# install supporting packages
RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       curl \
                       fakechroot \
                       locales \
                       iptables \
                       sudo \
                       wget \
                       curl \
                       zip \
                       unzip \
                       make \ 
                       bzip2 \ 
                       m4 \
                       apt-transport-https \
                       tzdata \
                       libnuma-dev \
                       libsss-nss-idmap-dev \
                       software-properties-common

# Adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server-2019.list

# install SQL Server ML services R and Python packages which will also install the mssql-server pacakge, the package for SQL Server itself
# if you want to install only Python or only R, you can add/remove the package as needed below
#RUN apt-get update && \
#    apt-get install -y mssql-mlservices-packages-r \
#                       mssql-mlservices-packages-py && \
# Only installing sql server
RUN apt-get update && \
    apt-get install -y mssql-server
#install mssql tools
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/msprod.list
RUN apt-get update && \
    apt-get install -y mssql-tools     

# Cleanup the Dockerfile
RUN apt-get clean && \
    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists    

# locale-gen
RUN locale-gen en_GB.UTF-8

# expose SQL Server port
EXPOSE 1433

CMD /opt/mssql/bin/sqlservr