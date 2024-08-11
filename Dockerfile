FROM cirrusci/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build web

EXPOSE 8080

CMD ["flutter", "run", "-d", "android", "--release"]
