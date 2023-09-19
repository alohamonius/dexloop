FROM node:16.15.0-alpine
ENV PORT=3000
ENV CHAINS=''
ENV POLLING=false
ENV DEBUG=false
WORKDIR /src
COPY . .
RUN yarn install
RUN npm run build

COPY dist ./dist

EXPOSE $PORT:$PORT
EXPOSE 80 443
CMD [ "node","dist/index.js", ${CHAINS}, ${POLLING},${DEBUG}]

