docker run -d \
    --name cubrid-debug \
    --hostname cubrid-debug \
    -p :22 \
    -p :30000 \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --privileged \
    youngjinj/cubrid-debug:develop
