FROM node:18
COPY . .
RUN yarn install
RUN yarn build
COPY . .
EXPOSE 3000
CMD ["yarn","start"]

#https://levelup.gitconnected.com/fully-automated-nextjs-builds-deployments-github-aws-ecr-fargate-service-ecs-part-4-4-94713de71df1