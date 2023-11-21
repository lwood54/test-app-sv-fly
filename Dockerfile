FROM node:20-alpine AS builder

RUN npm i -g pnpm@latest

RUN mkdir /app

COPY . /app

RUN cd /app && pnpm install && \
  pnpm build

FROM node:20-alpine

RUN npm i -g pnpm@latest

RUN mkdir /app

COPY --from=builder /app/build /app/build
COPY --from=builder /app/package.json /app/pnpm-lock.yaml /app/

RUN cd /app && \
  pnpm install --prod

WORKDIR /app

ENV PORT 5173

# Expose port 5173
EXPOSE 5173

CMD [ "node", "build/index.js" ]