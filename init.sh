#!/bin/bash
set -e

cd /home/frappe/frappe-bench

# Check agar site pehle se bani hui hai ya nahi (taaki restart pe data delete na ho)
if [ ! -d "sites/crm.localhost" ]; then
    echo "Site nahi mili. Nayi site create kar rahe hain..."
    
    # WhatsApp aur CRM apps fetch karo (WhatsApp pehle)
    bench get-app https://github.com/shridarpatil/frappe_whatsapp --branch main
    bench get-app https://github.com/frappe/crm --branch main
    
    # Nayi site banao
    bench new-site crm.localhost --mariadb-root-password 123 --admin-password admin --db-host mariadb --redis-cache redis:6379 --redis-queue redis:6379
    
    # Dono apps install karo
    bench --site crm.localhost install-app whatsapp
    bench --site crm.localhost install-app crm
    
    # CRM ko rebuild karo taaki WhatsApp integration dikhe
    bench build --app crm
else
    echo "Site pehle se exist karti hai. Setup skip kar rahe hain."
fi

# Bench start karo
echo "Starting Bench..."
bench start