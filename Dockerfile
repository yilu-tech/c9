FROM yilutech/cloud9:ubuntu

ENV NVM_DIR=/root/.nvm

SHELL ["/bin/bash", "-c"]

RUN source $NVM_DIR/nvm.sh \
 && source /root/.bashrc \
 && pm2 install pm2-logrotate
