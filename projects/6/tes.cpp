#include <iostream>
#include <string>

class Luar
{ // Kelas luar

public:
    int x;
    public:
    void tampil()
    {   
        std::cout << &((*this).x) << std::endl;
    }
};

int main()
{
    Luar luar;
    luar.tampil();
    return 0;
}
