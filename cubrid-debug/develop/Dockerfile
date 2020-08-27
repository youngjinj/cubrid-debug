FROM centos:7

MAINTAINER Joo Youngjin <youngjinj@cubrid.com>

RUN yum update -y \
	&& yum install -y	epel-release \
	&& yum install -y	yum-plugin-fastestmirror \
	&& yum install -y	sudo \
				vim \
				which \
				net-tools \
				telnet \
				nc \
				wget \
				expect \
				openssh-server \
				openssh-clients \
				sshpass \
	&& yum install -y	gdb \
				cgdb \
				ctags \
				cscope \
	&& yum install -y	centos-release-scl \
	&& yum install -y	devtoolset-8-\* \
				scl-utils \
				java-1.8.0-openjdk-devel \
				git \
				cmake \
				gcc-c++ \
				systemtap \
				systemtap-sdt-devel \
				bison \
				flex \
				ncurses-devel \
				ant \
				elfutils-libelf-devel \
				libtool \
				rpm-build \
	&& yum install -y --enablerepo='*-debug*' \
				java-1.8.0-openjdk-debuginfo \
	&& debuginfo-install -y	java-1.8.0-openjdk-headless \
				glibc \
				libgcc \
				libstdc++ \
				ncurses-libs \
				zlib \
	&& yum clean all

RUN localedef -f UTF-8 -i ko_KR ko_KR.utf8 \
	&& ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

ENV LC_ALL ko_KR.utf8
ENV LANG ko_KR.utf8
ENV LANGUAGE ko_KR.utf8

RUN sed -e "$(grep -n '# End of file' /etc/security/limits.conf  | cut -d':' -f1) i\*\t\t soft\t core\t\t unlimited\n*\t\t hard\t core\t\t unlimited\n*\t\t soft\t nofile\t\t 65536\n*\t\t hard\t nofile\t\t 65536\n*\t\t soft\t nproc\t\t 65536\n*\t\t hard\t nproc\t\t 65536\n" -i /etc/security/limits.conf \
	&& echo -e "\n*\t   soft\t   nproc     65536\n*\t   hard\t   nproc     65536" >> /etc/security/limits.d/20-nproc.conf

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N "" \
	&& ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N "" \
	&& ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N "" \
	&& chmod u+s /usr/bin/ping

RUN useradd cubrid \
	&& sed 102s/#\ %wheel/%wheel/g -i /etc/sudoers \
	&& sed s/wheel:x:10:/wheel:x:10:cubrid/g -i /etc/group

RUN mkdir -p /home/cubrid/github/cubrid \
	&& git clone -b develop --recursive https://github.com/CUBRID/cubrid.git /home/cubrid/github/cubrid

RUN source scl_source enable devtoolset-8 \
	&& cd /home/cubrid/github/cubrid \
	&& ./build.sh -m debug -p /home/cubrid/CUBRID -j /usr/lib/jvm/java build \
	&& echo 'java_stored_procedure=y' >> /home/cubrid/CUBRID/conf/cubrid.conf \
	&& mkdir -p /home/cubrid/CUBRID/databases \
		/home/cubrid/CUBRID/tmp \
		/home/cubrid/CUBRID/var/CUBRID_SOCK

COPY cubrid.sh /home/cubrid/

RUN echo ''						>> /home/cubrid/.bash_profile \
	&& echo 'export LC_ALL=ko_KR.utf8'		>> /home/cubrid/.bash_profile \
	&& echo 'export LANG=ko_KR.utf8'		>> /home/cubrid/.bash_profile \
	&& echo 'export LANGUAGE=ko_KR.utf8'		>> /home/cubrid/.bash_profile \
	&& echo ''					>> /home/cubrid/.bash_profile \
	&& echo 'umask 077'				>> /home/cubrid/.bash_profile \
	&& echo ''					>> /home/cubrid/.bash_profile \
	&& echo '. /home/cubrid/cubrid.sh'		>> /home/cubrid/.bash_profile \
	&& echo ''					>> /home/cubrid/.bash_profile \
	&& echo 'source scl_source enable devtoolset-8'	>> /home/cubrid/.bash_profile

RUN mkdir /home/cubrid/bin

COPY execute_build.sh /home/cubrid/bin/
COPY make_ctags_cscope.sh /home/cubrid/bin/

RUN chmod u+x /home/cubrid/bin/make_ctags_cscope.sh

COPY .gdbinit /home/cubrid/

COPY .vimrc /home/cubrid/

RUN chown -R cubrid:cubrid /home/cubrid/

USER cubrid

RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/cubrid/.vim/bundle/Vundle.vim \
	&& vim -E -u /home/cubrid/.vimrc +PluginInstall +qall -V || true

RUN cd /home/cubrid/github/cubrid \
	&& ctags -R /home/cubrid/github/cubrid

RUN cd /home/cubrid/github/cubrid \
	&& find /home/cubrid/github/cubrid \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.s' -o -name    '*.S' \) -print > cscope.files \
	&& cscope -b -i cscope.files

USER root

RUN mkdir /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
	&& ln -sf /usr/local/bin/docker-entrypoint.sh /entrypoint.sh

EXPOSE 22 5000 30000

ENTRYPOINT ["docker-entrypoint.sh"]
