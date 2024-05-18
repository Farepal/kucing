#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <bitset>
#include <cctype>
#include <map>
#include <algorithm>

using namespace std;

int firstLine = 16;
map<string, int> memoryStringToIntMap;

string removeComments(string line) {
    int pos = line.find("//");
    if (pos != string::npos)
        line = line.substr(0, pos);
    return line;
}

bool isNumber(const std::string& str) {
    for (char const &c : str)
        if (std::isdigit(c) == 0) 
            return false;
    return true;
}

int parsingPredefinedSymbolToNumber(string line) {
    if (isNumber(line)) {
        return stoi(line);
    }
    else if (memoryStringToIntMap.find(line) == memoryStringToIntMap.end()) {
            memoryStringToIntMap[line] = firstLine;
            firstLine++;
    }
    return memoryStringToIntMap[line];
}

string removeWhiteSpace(string line) {
    string result = "";
    vector<char> whiteSpaces = {' ', '\t', '\n', '\v', '\f', '\r'};
    for (int i = 0; i < line.length(); i++)
        if (find(whiteSpaces.begin(), whiteSpaces.end(), line[i]) == whiteSpaces.end())
            result += line[i];
    return result;
}

string cleanLine(string line) {
    line = removeComments(line);
    line = removeWhiteSpace(line);
    return line;
}

string parseToBinary(string line) {
    // A instruction
    int pos = line.find("@");
    if (pos != string::npos) {
        line = line.substr(pos+1, line.length());
        line = bitset<16>(parsingPredefinedSymbolToNumber(line)).to_string();
        return line;
    }

    // C Instruction
    bitset<16> result = 0;


    // dest
    int posEqualSymbol = line.find("=");
    string ddd = "000";
    if (posEqualSymbol != string::npos) {
        string dest = line.substr(0, posEqualSymbol);
        if (dest.find("A") != string::npos)
            ddd[0] = '1';
        if (dest.find("D") != string::npos)
            ddd[1] = '1';
        if (dest.find("M") != string::npos)
            ddd[2] = '1';
    }

    // comp
    int posSemiColonSymbol = line.find(";");
    int firstComp = posEqualSymbol==string::npos ? 0 : posEqualSymbol+1;
    int endComp = posSemiColonSymbol==string::npos ? line.length() : posSemiColonSymbol;
    string comp = line.substr(firstComp, endComp);

    string a = "0";
    if (comp.find("M") != string::npos)
        a = "1";
    
    string AorM = a == "1" ? "M" : "A";

    string cccccc = "000000";
    if (comp.find("0") != string::npos)
        cccccc = "101010";
    else if (comp.find("D+1") != string::npos)
        cccccc = "011111";
    else if (comp.find(AorM + "+1") != string::npos)
        cccccc = "110111";
    else if (comp.find("D-1") != string::npos)
        cccccc = "001110";
    else if (comp.find(AorM + "-1") != string::npos)
        cccccc = "110010";
    else if (comp.find("D+" + AorM) != string::npos || comp.find(AorM + "+D") != string::npos)
        cccccc = "000010";
    else if (comp.find("D-A") != string::npos || comp.find("D-M") != string::npos)
        cccccc = "010011";
    else if (comp.find("A-D") != string::npos || comp.find("M-D") != string::npos)
        cccccc = "000111";
    else if (comp.find("D&" + AorM) != string::npos || comp.find(AorM + "&D") != string::npos)
        cccccc = "000000";
    else if (comp.find("D|" + AorM) != string::npos || comp.find(AorM + "|D") != string::npos)
        cccccc = "010101";
    else if (comp.find("!" + AorM) != string::npos)
        cccccc = "110001";
    else if (comp.find("-" + AorM) != string::npos)
        cccccc = "110011";
    else if (comp.find("-D") != string::npos)
        cccccc = "001111";
    else if (comp.find("!D") != string::npos)
        cccccc = "001101";
    else if (comp.find("D") != string::npos)
        cccccc = "001100";
    else if (comp.find("A") != string::npos || comp.find("M") != string::npos)
        cccccc = "110000";
    else if (comp.find("-1") != string::npos)
        cccccc = "111010";
    else if (comp.find("1") != string::npos)
        cccccc = "111111";

    string jjj = "000";
    string jump = posSemiColonSymbol==string::npos ? "" : line.substr(posSemiColonSymbol+1, line.length());
    if (jump.length() > 0) {
        if (jump.find("JGT") != string::npos)
            jjj = "001";
        else if (jump.find("JEQ") != string::npos)
            jjj = "010";
        else if (jump.find("JGE") != string::npos)
            jjj = "011";
        else if (jump.find("JLT") != string::npos)
            jjj = "100";
        else if (jump.find("JNE") != string::npos)
            jjj = "101";
        else if (jump.find("JLE") != string::npos)
            jjj = "110";
        else if (jump.find("JMP") != string::npos)
            jjj = "111";
    }
    return "111" + a + cccccc + ddd + jjj;
}

int main() {
    string line;
    ifstream inFile("./rect/RectL.asm");
    vector <string> lines;

    memoryStringToIntMap["SP"] = 0;
    memoryStringToIntMap["LCL"] = 1;
    memoryStringToIntMap["ARG"] = 2;
    memoryStringToIntMap["THIS"] = 3;
    memoryStringToIntMap["THAT"] = 4;
    for (int i = 0; i < 16; i++)
        memoryStringToIntMap["R" + to_string(i)] = i;
    memoryStringToIntMap["SCREEN"] = 16384;
    memoryStringToIntMap["KBD"] = 24576;

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

    ofstream outFile("./rect/RectL.hack");
    
    if (outFile.is_open()) {
        int count = 0;
        for (int i = 0; i < lines.size(); i++) {
            string line = lines[i];
            if (line[0] == '(') {
                string label = line.substr(1, line.length()-2);
                memoryStringToIntMap[label] = i-count;
                count++;
            }
        }
        for (int i = 0; i < lines.size(); i++) {
            if (lines[i][0] == '(')
                continue;
            string hasilBin = parseToBinary(lines[i]);
            outFile << hasilBin << endl;
        }
        outFile.close();
    } else {
        cout << "Unable to open file" << endl;
    }

    return 0;
}
