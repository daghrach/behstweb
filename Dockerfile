#NODE
FROM node:4
WORKDIR /app
ADD . /app
EXPOSE 3000
RUN  bash install_dependencies.sh
CMD  ["node","app.js"]
