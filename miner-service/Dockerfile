FROM node:16.15.0-alpine
ENV CHAINS=''
ENV POLLING=false
ENV DEBUG=false
ENV DYNAMO_TABLE=''
WORKDIR /src
COPY . .
RUN yarn install
RUN yarn build
RUN yarn codegen

COPY dist ./dist

# EXPOSE $PORT:$PORT
# EXPOSE 80 443
CMD ["sh", "-c", "node dist/index.js ${CHAINS} ${DYNAMO_TABLE} ${POLLING} ${DEBUG}" ]