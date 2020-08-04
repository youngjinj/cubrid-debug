docker run -d \
    --name cubrid-debug \
    --hostname cubrid-debug \
    -e GIT_REPO=youngjinj \
    -p :22 \
    -p :30000 \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --privileged \
    youngjinj/cubrid-debug:develop
