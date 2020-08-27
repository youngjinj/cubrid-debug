#!/bin/bash

cd /home/cubrid/github/cubrid \
	&& ctags -R /home/cubrid/github/cubrid

cd /home/cubrid/github/cubrid \
	&& find /home/cubrid/github/cubrid \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.s' -o -name    '*.S' \) -print > cscope.files \
	&& cscope -b -i cscope.files
