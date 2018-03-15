FROM registry-vpc.cn-hangzhou.aliyuncs.com/midian_prod/node:8.9.3

# Create app directory
RUN mkdir -p /home/Service/zftBS
WORKDIR /home/Service/zftBS

##change npm registry
#RUN npm config set registry https://registry.npm.taobao.org

# Bundle app source
COPY . /home/Service/zftBS

ENV NPM_CONFIG_LOGLEVEL info
RUN npm install --production
CMD pm2 start zftBS.js --no-daemon