const fs = require('fs');
const path = require('path');

// Parser Class
class Parser {
    constructor(inputFilePath) {
        this.inputFilePath = inputFilePath;
        this.lines = fs.readFileSync(inputFilePath, 'utf-8').split('\n');
        this.currentLine = '';
        this.currentIndex = -1;
    }

    hasMoreLines() {
        return this.currentIndex + 1 < this.lines.length;
    }

    advance() {
        if (this.hasMoreLines()) {
            this.currentIndex++;
            this.currentLine = this.cleanLine(this.lines[this.currentIndex]);
        }
    }

    cleanLine(line) {
        return this.trim(this.removeComments(line));
    }

    trim(line) {
        return line.trim();
    }

    removeComments(line) {
        const pos = line.indexOf('//');
        return pos !== -1 ? line.substring(0, pos) : line;
    }

    commandType() {
        const firstWord = this.currentLine.split(' ')[0];
        const commandTypes = {
            'push': 'C_PUSH',
            'pop': 'C_POP',
            'label': 'C_LABEL',
            'goto': 'C_GOTO',
            'if-goto': 'C_IF',
            'function': 'C_FUNCTION',
            'return': 'C_RETURN',
            'call': 'C_CALL',
            '': 'C_EMPTY'
        };
        return commandTypes[firstWord] || 'C_ARITHMETIC';
    }

    arg1() {
        if (this.commandType() === 'C_ARITHMETIC') {
            return this.currentLine;
        }
        return this.currentLine.split(' ')[1];
    }

    arg2() {
        if (this.commandType() === 'C_PUSH' || this.commandType() === 'C_POP' || this.commandType() === 'C_FUNCTION' || this.commandType() === 'C_CALL') {
            return parseInt(this.currentLine.split(' ')[2]);
        }
        return null;
    }
}

// CodeWriter Class
class CodeWriter {
    constructor(outputFilePath) {
        this.outputFilePath = outputFilePath;
        this.aCount = 0;
        this.staticMemoryNumber = 16;
        this.staticMappingNumber = {};
        this.fileName = path.basename(outputFilePath, '.asm');
    }

    writeArithmetic(command) {
        const template = {
            'add': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M+D',
            'sub': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M-D',
            'neg': '@SP\nA=M-1\nM=-M',
            'eq': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${this.aCount}\nD;JEQ\n@SP\nA=M-1\nM=0\n@CONTINUE${this.aCount}\n0;JMP\n(TRUE${this.aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${this.aCount})`,
            'gt': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${this.aCount}\nD;JGT\n@SP\nA=M-1\nM=0\n@CONTINUE${this.aCount}\n0;JMP\n(TRUE${this.aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${this.aCount})`,
            'lt': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${this.aCount}\nD;JLT\n@SP\nA=M-1\nM=0\n@CONTINUE${this.aCount}\n0;JMP\n(TRUE${this.aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${this.aCount})`,
            'and': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M&D',
            'or': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M|D',
            'not': '@SP\nA=M-1\nM=!M'
        };
        this.aCount++;
        fs.appendFileSync(this.outputFilePath, template[command] + '\n');
    }

    writePushPop(command, segment, index) {
        const staticLabel = `${this.fileName}.${index}`;
        if (segment === 'static') {
            if (!this.staticMappingNumber[staticLabel]) {
                this.staticMappingNumber[staticLabel] = this.staticMemoryNumber;
                this.staticMemoryNumber++;
            }
        }

        if (command === 'push') {
            const templatePush = {
                'constant': `@${index}\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'local': `@${index}\nD=A\n@LCL\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'argument': `@${index}\nD=A\n@ARG\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'this': `@${index}\nD=A\n@THIS\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'that': `@${index}\nD=A\n@THAT\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'temp': `@${index}\nD=A\n@5\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'pointer': `@${index}\nD=A\n@3\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                'static': `@${this.staticMappingNumber[staticLabel]}\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
            };
            fs.appendFileSync(this.outputFilePath, templatePush[segment] + '\n');
        } else if (command === 'pop') {
            const templatePop = {
                'local': `@${index}\nD=A\n@LCL\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'argument': `@${index}\nD=A\n@ARG\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'this': `@${index}\nD=A\n@THIS\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'that': `@${index}\nD=A\n@THAT\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'temp': `@${index}\nD=A\n@5\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'pointer': `@${index}\nD=A\n@3\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                'static': `@${this.staticMappingNumber[staticLabel]}\nD=A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            };
            fs.appendFileSync(this.outputFilePath, templatePop[segment] + '\n');
        }
    }

    writeLabel(label) {
        fs.appendFileSync(this.outputFilePath, `(${label})\n`);
    }

    writeGoto(label) {
        fs.appendFileSync(this.outputFilePath, `@${label}\n0;JMP\n`);
    }

    writeIf(label) {
        fs.appendFileSync(this.outputFilePath, `@SP\nM=M-1\nA=M\nD=M\n@${label}\nD;JNE\n`);
    }

    close() {
        fs.appendFileSync(this.outputFilePath, '');
    }
}

// Main Logic
const main = () => {
    const allFiles = {
        'MemoryAccess': [
            'BasicTest',
            'StaticTest',
            'PointerTest'
        ],
        'StackArithmetic': [
            'SimpleAdd',
            'StackTest'
        ]
    };

    for (const folderName in allFiles) {
        allFiles[folderName].forEach(fileName => {
            const inputPath = path.join('.', folderName, fileName, `${fileName}.vm`);
            const outputPath = path.join('.', folderName, fileName, `${fileName}.asm`);

            fs.writeFileSync(outputPath, '');

            const parser = new Parser(inputPath);
            const codeWriter = new CodeWriter(outputPath);

            while (parser.hasMoreLines()) {
                parser.advance();

                const commandType = parser.commandType();
                if (commandType === 'C_ARITHMETIC') {
                    codeWriter.writeArithmetic(parser.arg1());
                } else if (commandType === 'C_PUSH' || commandType === 'C_POP') {
                    codeWriter.writePushPop(commandType.toLowerCase().split('_')[1], parser.arg1(), parser.arg2());
                }
            }

            codeWriter.close();
        });
    }
};

// Execute the Main Function
main();
