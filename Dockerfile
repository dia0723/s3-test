# node 24 alpine 버전은 경량 리눅스 이미지로
# 적은 용량을 사용하는 AWS에서 유용함
FROM node:24-alpine AS builder

# 작업 디렉토리를 /app으로 설정
WORKDIR /app

#pacakge.json과 package-lock.json 을 컨테이너에 복사
# '*'은 와일드 카드로 뭐든 다 받음
# 결론은 pacakge로 시작하는 .json 파일 전부 복사함.
COPY package.json ./
# npm 패키지 섩치
RUN npm install

#패키지 설치하고 나온 정보들 복사 (node_modules 필요하니까)
COPY module-federation.config.ts ./
# 구성원 node_modules 기반으로 build 진행
#여기서 dist 폴더에 빌드 정보가 들어감
RUN npm run build

#경량형 nginx 구성
FROM nginx:alpine

COPY docker/nginx.conf /etx/nginx/nginx.xonf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

cmd["nginx", "-g", "daemon off,"]
