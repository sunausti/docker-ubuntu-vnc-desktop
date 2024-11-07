docker run -p 6080:80 -p 5900:5900 \
    -v /dev:/dev \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    ubuntu-desktop-lxde-vnc-realsense:v0.1
