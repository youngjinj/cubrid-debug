cat /usr/local/apache2/htdocs/doxygen.options |
while read OPTION_LINE
do
    OPTION=`echo $OPTION_LINE | awk '{printf $1}'`
    sed -e "/^$OPTION/ c\ $OPTION_LINE" -i /usr/local/apache2/htdocs/doxygen.conf
done
