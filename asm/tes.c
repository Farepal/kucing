#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int main() {
    const char *filename = "./flg.txt"; // Nama file
    char buffer[24];                 // Buffer untuk menyimpan data
    ssize_t bytes_read;              // Jumlah byte yang dibaca

    // Membuka file dalam mode read-only
    int fd = open(filename, O_RDONLY);
    printf("fd: %d\n", fd);
    printf("filename: %s\n", filename);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }

    // Membaca hingga 24 byte dari file
    bytes_read = read(fd, buffer, sizeof(buffer));
    printf("bytes_read: %ld\n", bytes_read);
    if (bytes_read == -1) {
        perror("Error reading file");
        close(fd);
        return 1;
    }

    // Menulis data ke stdout
    if (write(STDOUT_FILENO, buffer, bytes_read) == -1) {
        perror("Error writing to stdout");
        close(fd);
        return 1;
    }

    // Menutup file descriptor
    close(fd);
    return 0;
}
