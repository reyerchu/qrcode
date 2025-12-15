#!/bin/bash

# QRBTF QR Code Generator Service Setup Script
# This script sets up the QRBTF service to run on qrcode.defintek.io
# Run with: sudo bash setup-qrbtf-service.sh

set -e

echo "========================================="
echo "QRBTF Service Setup for qrcode.defintek.io"
echo "========================================="

# Variables
APACHE_CONF_SOURCE="/home/reyerchu/qrbtf/qrcode.defintek.io.conf"
APACHE_CONF_DEST="/etc/apache2/sites-available/qrcode.defintek.io.conf"
SYSTEMD_SERVICE_SOURCE="/home/reyerchu/qrbtf/qrbtf.service"
SYSTEMD_SERVICE_DEST="/etc/systemd/system/qrbtf.service"

# Step 1: Copy Apache configuration
echo "[1/6] Copying Apache virtual host configuration..."
cp "$APACHE_CONF_SOURCE" "$APACHE_CONF_DEST"
echo "      ✓ Apache configuration copied to $APACHE_CONF_DEST"

# Step 2: Copy systemd service file
echo "[2/6] Copying systemd service file..."
cp "$SYSTEMD_SERVICE_SOURCE" "$SYSTEMD_SERVICE_DEST"
echo "      ✓ Systemd service copied to $SYSTEMD_SERVICE_DEST"

# Step 3: Enable required Apache modules
echo "[3/6] Enabling required Apache modules..."
a2enmod proxy proxy_http proxy_wstunnel rewrite headers ssl > /dev/null 2>&1 || true
echo "      ✓ Apache modules enabled (proxy, proxy_http, proxy_wstunnel, rewrite, headers, ssl)"

# Step 4: Enable the Apache site
echo "[4/6] Enabling Apache site qrcode.defintek.io..."
a2ensite qrcode.defintek.io.conf > /dev/null 2>&1
echo "      ✓ Apache site enabled"

# Step 5: Test Apache configuration
echo "[5/6] Testing Apache configuration..."
if apache2ctl configtest 2>&1 | grep -q "Syntax OK"; then
    echo "      ✓ Apache configuration syntax is OK"
else
    echo "      ✗ Apache configuration test failed!"
    apache2ctl configtest
    exit 1
fi

# Step 6: Reload Apache and start service
echo "[6/6] Reloading Apache and starting QRBTF service..."
systemctl reload apache2
systemctl daemon-reload
systemctl enable qrbtf.service
systemctl start qrbtf.service
echo "      ✓ Apache reloaded and QRBTF service started"

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Service Details:"
echo "  - URL: https://qrcode.defintek.io"
echo "  - Internal Port: 3044"
echo "  - Service: qrbtf.service"
echo ""
echo "Useful Commands:"
echo "  - Check service status: sudo systemctl status qrbtf"
echo "  - View logs: sudo journalctl -u qrbtf -f"
echo "  - Restart service: sudo systemctl restart qrbtf"
echo ""
echo "Don't forget to update your DNS to point qrcode.defintek.io to this server!"
echo ""

