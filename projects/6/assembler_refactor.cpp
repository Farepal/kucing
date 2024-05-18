#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <bitset>
#include <cctype>
#include <map>
#include <algorithm>
#include <utility>

using namespace std;

class C_INSTRUCTION
{
private:
    string assemblyInstruction;
    map<string, string> compTable;
    map<string, string> jumpTable;
    string ddd;
    string cccccc;
    string jjj;
    string result;

    string dest()
    {
        int pos = assemblyInstruction.find("=");
        if (pos != string::npos)
            return assemblyInstruction.substr(0, pos);
        return "";
    }

    string dest(string dest)
    {
        if (dest == "")
            return "000";
        string result = "";
        if (dest.find("A") != string::npos)
            result += "1";
        else
            result += "0";
        if (dest.find("D") != string::npos)
            result += "1";
        else
            result += "0";
        if (dest.find("M") != string::npos)
            result += "1";
        else
            result += "0";
        return result;
    }

    string jump()
    {
        int pos = assemblyInstruction.find(";");
        if (pos != string::npos)
            return assemblyInstruction.substr(pos + 1, assemblyInstruction.length());
        return "";
    }

    string jump(string jump)
    {
        if (jump == "")
            return "000";
        return jumpTable[jump];
    }

    string comp()
    {
        int pos = assemblyInstruction.find("=");
        if (pos != string::npos)
            assemblyInstruction = assemblyInstruction.substr(pos + 1, assemblyInstruction.length());
        pos = assemblyInstruction.find(";");
        if (pos != string::npos)
            return assemblyInstruction.substr(0, pos);
        return assemblyInstruction;
    }

    string comp(string comp)
    {
        return compTable[comp];
    }

    void initializeCompTable()
    {
        compTable.insert({"0", "0101010"});
        compTable.insert({"1", "0111111"});
        compTable.insert({"-1", "0111010"});
        compTable.insert({"D", "0001100"});
        compTable.insert({"A", "0110000"});
        compTable.insert({"!D", "0001101"});
        compTable.insert({"!A", "0110001"});
        compTable.insert({"-D", "0001111"});
        compTable.insert({"-A", "0110011"});
        compTable.insert({"D+1", "0011111"});
        compTable.insert({"A+1", "0110111"});
        compTable.insert({"D-1", "0001110"});
        compTable.insert({"A-1", "0110010"});
        compTable.insert({"D+A", "0000010"});
        compTable.insert({"D-A", "0010011"});
        compTable.insert({"A-D", "0000111"});
        compTable.insert({"D&A", "0000000"});
        compTable.insert({"D|A", "0010101"});
        compTable.insert({"M", "1110000"});
        compTable.insert({"!M", "1110001"});
        compTable.insert({"-M", "1110011"});
        compTable.insert({"M+1", "1110111"});
        compTable.insert({"M-1", "1110010"});
        compTable.insert({"D+M", "1000010"});
        compTable.insert({"D-M", "1010011"});
        compTable.insert({"M-D", "1000111"});
        compTable.insert({"D&M", "1000000"});
        compTable.insert({"D|M", "1010101"});
    }

    void initializeJumpTable()
    {
        jumpTable.insert({"", "000"});
        jumpTable.insert({"JGT", "001"});
        jumpTable.insert({"JEQ", "010"});
        jumpTable.insert({"JGE", "011"});
        jumpTable.insert({"JLT", "100"});
        jumpTable.insert({"JNE", "101"});
        jumpTable.insert({"JLE", "110"});
        jumpTable.insert({"JMP", "111"});
    }

public:
    C_INSTRUCTION(string assemblyInstruction)
    {
        this->assemblyInstruction = assemblyInstruction;
        initializeCompTable();
        initializeJumpTable();
        ddd = dest(dest());
        cccccc = comp(comp());
        jjj = jump(jump());
        result = "111" + cccccc + ddd + jjj;
    }

    string getResult()
    {
        return result;
    }
};

class A_INSTRUCTION
{
private:
    string assemblyInstruction;
    string result;

    bool isNumber(string address)
    {
        for (int i = 0; i < address.length(); i++)
            if (!isdigit(address[i]))
                return false;
        return true;
    }

public:
    A_INSTRUCTION(string assemblyInstruction, map<string, int> &symbolTable, int &variableAddress)
    {
        this->assemblyInstruction = assemblyInstruction;
        string symbol = assemblyInstruction.substr(1, assemblyInstruction.length());
        if (isNumber(symbol))
            result = bitset<16>(stoi(symbol)).to_string();
        else
        {
            if (symbolTable.find(symbol) == symbolTable.end())
                symbolTable[symbol] = variableAddress++;
            result = bitset<16>(symbolTable[symbol]).to_string();
        }
    }

    string getResult()
    {
        return result;
    }
};

class L_INSTRUCTION
{
private:
    string assemblyInstruction;

public:
    L_INSTRUCTION(string assemblyInstruction, map<string, int> &symbolTable, int lineInROM)
    {
        string symbol = assemblyInstruction.substr(1, assemblyInstruction.length() - 2);
        symbolTable[symbol] = lineInROM;
    }
};

class Parser
{
private:
    ifstream inFile;
    ofstream outFile;
    string inputFilePath;
    string outputFilePath;
    map<string, int> symbolTable;
    vector<string> binaryInstructions;
    int variableAddress = 16;

    bool hasMoreLines(ifstream &inFile);
    bool isInstruction(const string &line);
    string instructionType(const string &line);
    string removeComments(const string &line);
    string removeWhiteSpace(const string &line);
    string cleanLine(const string &line);
    void initializeSymbolTable();
    void firstPass();
    void secondPass();
    void advance(const string &line);

public:
    Parser(string inputFilePath, string outputFilePath)
    {
        this->inputFilePath = inputFilePath;
        this->outputFilePath = outputFilePath;
        initializeSymbolTable();
        firstPass();
        secondPass();
    }
};

void Parser::initializeSymbolTable()
{
    symbolTable.insert({"SP", 0});
    symbolTable.insert({"LCL", 1});
    symbolTable.insert({"ARG", 2});
    symbolTable.insert({"THIS", 3});
    symbolTable.insert({"THAT", 4});
    symbolTable.insert({"R0", 0});
    symbolTable.insert({"R1", 1});
    symbolTable.insert({"R2", 2});
    symbolTable.insert({"R3", 3});
    symbolTable.insert({"R4", 4});
    symbolTable.insert({"R5", 5});
    symbolTable.insert({"R6", 6});
    symbolTable.insert({"R7", 7});
    symbolTable.insert({"R8", 8});
    symbolTable.insert({"R9", 9});
    symbolTable.insert({"R10", 10});
    symbolTable.insert({"R11", 11});
    symbolTable.insert({"R12", 12});
    symbolTable.insert({"R13", 13});
    symbolTable.insert({"R14", 14});
    symbolTable.insert({"R15", 15});
    symbolTable.insert({"SCREEN", 16384});
    symbolTable.insert({"KBD", 24576});
}

string Parser::removeWhiteSpace(const string &line)
{
    string result = "";
    vector<char> whiteSpaces = {' ', '\t', '\n', '\v', '\f', '\r'};
    for (int i = 0; i < line.length(); i++)
        if (find(whiteSpaces.begin(), whiteSpaces.end(), line[i]) == whiteSpaces.end())
            result += line[i];
    return result;
}

string Parser::cleanLine(const string &line)
{
    string result = removeComments(line);
    result = removeWhiteSpace(result);
    return result;
}

string Parser::removeComments(const string &line)
{
    int pos = line.find("//");
    if (pos != string::npos)
        return line.substr(0, pos);
    return line;
}

bool Parser::hasMoreLines(ifstream &inFile)
{
    return inFile.peek() != EOF;
}

string Parser::instructionType(const string &line)
{
    switch (line[0])
    {
    case '@':
        return "A_INSTRUCTION";
    case '(':
        return "L_INSTRUCTION";
    default:
        return "C_INSTRUCTION";
    }
}

bool Parser::isInstruction(const string &line)
{
    return line.length() > 0;
}


void Parser::firstPass()
{
    inFile.open(inputFilePath);
    string line;
    int lineNumber = 0;
    while (hasMoreLines(inFile))
    {
        getline(inFile, line);
        line = cleanLine(line);
        if (isInstruction(line))
        {
            if (instructionType(line) == "L_INSTRUCTION")
                L_INSTRUCTION lInstruction(line, symbolTable, lineNumber);
            else
                lineNumber++;
        }
    }
    inFile.close();
}

void Parser::advance(const string &line)
{
    if (isInstruction(line))
    {
        if (instructionType(line) == "A_INSTRUCTION")
        {
            A_INSTRUCTION aInstruction(line, symbolTable, variableAddress);
            outFile << aInstruction.getResult() << endl;
        }
        else if (instructionType(line) == "C_INSTRUCTION")
        {
            C_INSTRUCTION cInstruction(line);
            outFile << cInstruction.getResult() << endl;
        }
    }
}

void Parser::secondPass()
{
    inFile.open(inputFilePath);
    outFile.open(outputFilePath);
    string line;
    while (hasMoreLines(inFile))
    {
        getline(inFile, line);
        line = cleanLine(line);
        advance(line);
    }
    inFile.close();
    outFile.close();
}


int main()
{
    Parser parser("./rect/Rect.asm", "./rect/Rect.hack");
    return 0;
}