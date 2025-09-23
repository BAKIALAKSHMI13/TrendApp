# Use lightweight nginx image
FROM nginx:alpine

# Copy the built dist folder to nginx html directory
COPY dist/ /usr/share/nginx/html

# Expose port 80 inside container
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
