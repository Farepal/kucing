# login-dulu

# Description
Just read the file!

# Solution
Login username sebagai ```admin``` dan passwordnya ```" union select rootpage, type, name from sqlite_master --``` akan membuat server mengira anda login bahkan ketika databasenya kosong  
Lalu tinggal pergi ke url /flag

# Flag
FindITCTF{manc1n9_m4n14K}

# Author
repalfarel#0466

# How to Run?
```
docker build -t login .
docker run -p 7070:7070 login
```