FROM node:18
COPY . .
RUN yarn install
RUN yarn build
COPY . .
EXPOSE 3000
CMD ["yarn","start"]