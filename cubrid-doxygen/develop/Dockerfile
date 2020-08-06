FROM httpd:2.4

MAINTAINER Joo Youngjin <youngjinj@cubrid.com>

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y locales \
                          procps \
                          vim \
    && apt-get install -y doxygen \
                          graphviz \
                          git \
    && apt-get clean

RUN localedef -f UTF-8 -i ko_KR ko_KR.utf8 \
    && ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

ENV LC_ALL ko_KR.utf8
ENV LANG ko_KR.utf8
ENV LANGUAGE ko_KR.utf8

RUN sed -e "$(grep -n '# End of file' /etc/security/limits.conf  | cut -d':' -f1) i\*\t\t soft\t nofile\t\t 65536\n*\t\t hard\t nofile\t\t 65536\n*\t\t soft\t nproc\t\t 65536\n*\t\t hard\t nproc\t\t 65536\n" -i /etc/security/limits.conf

RUN git clone -b develop --recursive https://github.com/CUBRID/cubrid.git /usr/local/apache2/htdocs/cubrid

RUN echo '' >> /etc/profile \
    && echo 'export LC_ALL=ko_KR.utf8' >> /etc/profile \
    && echo 'export LANG=ko_KR.utf8' >> /etc/profile \
    && echo 'export LANGUAGE=ko_KR.utf8' >> /etc/profile 

COPY .vimrc /root/

COPY doxygen_change.sh /usr/local/apache2/htdocs/
COPY doxygen.options /usr/local/apache2/htdocs/

RUN doxygen -g /usr/local/apache2/htdocs/doxygen.conf \
    && mkdir -p /usr/local/apache2/htdocs/doxygen \
    && bash /usr/local/apache2/htdocs/doxygen_change.sh \
    && doxygen /usr/local/apache2/htdocs/doxygen.conf

WORKDIR /usr/local/apache2/htdocs

EXPOSE 80

CMD ["httpd-foreground"]
