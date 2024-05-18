#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <bitset>
#include <cctype>
#include <map>
#include <algorithm>

using namespace std;

class Pars

string trim(string line) {
    int first = line.find_first_not_of(" \t\n\v\f\r");
    int last = line.find_last_not_of(" \t\n\v\f\r");
    if (string::npos == first or string::npos == last) {
        return "";
    }
    return line.substr(first, (last - first + 1));
}

string removeComments(string line) {
    int pos = line.find("//");
    if (pos != string::npos)
        line = line.substr(0, pos);
    return line;
}

string cleanLine(string line) {
    line = removeComments(line);
    line = trim(line);
    return line;
}

int main()
{
    string line;
    ifstream inFile("./MemoryAccess/BasicTest/BasicTest.vm");
    vector <string> lines;

    if (inFile.is_open()) {
        while (getline(inFile, line)) {
            line = cleanLine(line);
            if (line.length() > 0) {
                lines.push_back(line);
            }
        }
        inFile.close();
    } else {
        cout << "Unable to open file" << endl;
    }

    return 0;
}