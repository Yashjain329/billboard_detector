# ===== Build Stage =====
FROM cirrusci/flutter:stable AS build

WORKDIR /app

# Copy pubspec first for dependency caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Enable web support & build release
RUN flutter config --enable-web
RUN flutter build web --release

# ===== Runtime Stage =====
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]