FROM debian:12

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    novnc websockify \
    x11vnc \
    supervisor \
    curl wget \
    && apt-get clean

# Create necessary directories
RUN mkdir -p /root/.vnc /opt/novnc /var/log/supervisor

# Set up VNC password
RUN echo "mypassword" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd

# Download and set up noVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz | tar xz --strip-components=1 -C /opt/novnc
RUN ln -s /opt/novnc/utils/novnc_proxy /usr/bin/novnc_proxy

# Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the noVNC port
EXPOSE 8080

# Start the Supervisor service
CMD ["/usr/bin/supervisord", "-n"]
