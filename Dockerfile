######################## Build Stage: Node.js application #######################
FROM node:14 AS builder

WORKDIR /app
COPY . .
RUN npm install

# Build the Node.js application
RUN npm run build

######################## Run Stage: Serve the application using Apache #######################
FROM httpd:2.4

# Create a new directory
RUN mkdir -p /var/www/services/limo-landing

# Copy the Apache configuration file
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# Copy the built application from the previous stage
COPY --from=builder /app/dist/ /var/www/services/limo-landing

# Start Apache in the foreground
CMD ["httpd-foreground"]
