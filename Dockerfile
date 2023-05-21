FROM node:19.7.0

WORKDIR /app

# copy project file
COPY package.json .
COPY package-lock.json .

RUN npm config set legacy-peer-deps true && npm install

# copy app
COPY . .
ENV NODE_ENV production

# expose port
EXPOSE 3000

# 运行应用程序
CMD ["npm", "start"]
