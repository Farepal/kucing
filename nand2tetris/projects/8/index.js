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
        this.staticMemoryNumber = 18;
        this.staticMappingNumber = {};
        this.inputFileNameWithoutExtension = path.basename(outputFilePath, '.asm');
        this.currentFunctionName = '';
    }

    setInputFileName(inputFileNameWithoutExtension) {
        this.inputFileNameWithoutExtension = inputFileNameWithoutExtension;
    }

    saveToFileAndWriteComment(comment, content) {
        fs.appendFileSync(this.outputFilePath, `\n// ${comment}\n${content}\n`);
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
        this.saveToFileAndWriteComment(command, template[command]);

        this.aCount++;
    }

    writePushPop(command, segment, index) {
        const staticLabel = `${this.inputFileNameWithoutExtension}.${index}`;
        if (segment === 'static') {
            if (!this.staticMappingNumber[staticLabel]) {
                this.staticMappingNumber[staticLabel] = this.staticMemoryNumber;
                this.staticMemoryNumber++;
            }
        }

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

        const templatePop = {
            'local': `@${index}\nD=A\n@LCL\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'argument': `@${index}\nD=A\n@ARG\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'this': `@${index}\nD=A\n@THIS\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'that': `@${index}\nD=A\n@THAT\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'temp': `@${index}\nD=A\n@5\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'pointer': `@${index}\nD=A\n@3\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
            'static': `@${this.staticMappingNumber[staticLabel]}\nD=A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
        };

        const firstComment = `${command} ${segment} ${index}`;
        let secondComment = '';
        if (segment === 'static') {
            secondComment = ` || ${staticLabel} RAM[${this.staticMappingNumber[staticLabel]}]`;
        } else if (segment === 'pointer') {
            secondComment = ` || ${command} ${index === 0 ? 'THIS' : 'THAT'}`;
        }
        const comment = `${firstComment}${secondComment}`;

        this.saveToFileAndWriteComment(comment, command === 'push' ? templatePush[segment] : templatePop[segment]);
    }

    writeLabel(label) {
        this.saveToFileAndWriteComment(label, `(${label})`);
    }

    writeGoto(label) {
        this.saveToFileAndWriteComment(`GOTO ${label}`, `@${label}\n0;JMP`);
    }

    writeIf(label) {
        this.saveToFileAndWriteComment(`IF-GOTO ${label}`, `@SP\nM=M-1\nA=M\nD=M\n@${label}\nD;JNE`);
    }

    writeCall(functionName, numArgs) {
        const returnAddress = `RETURN${this.aCount}`;

        this.saveToFileAndWriteComment(`CALL ${functionName} ${numArgs}`, ``);
        this.saveToFileAndWriteComment(`PUSH (${returnAddress})`, `@${returnAddress}\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1`);
        this.saveToFileAndWriteComment(`PUSH LCL`, '@LCL\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1');
        this.saveToFileAndWriteComment(`PUSH ARG`, '@ARG\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1');
        this.writePushPop('push', 'pointer', 0); // push THIS
        this.writePushPop('push', 'pointer', 1); // push THAT
        this.saveToFileAndWriteComment(`ARG = SP - 5 - numArgs`, `@SP\nD=M\n@5\nD=D-A\n@${numArgs}\nD=D-A\n@ARG\nM=D`);
        this.saveToFileAndWriteComment(`LCL = SP`, '@SP\nD=M\n@LCL\nM=D');
        this.writeGoto(functionName);
        this.writeLabel(returnAddress);

        this.aCount++;
    }

    writeFunction(functionName, numLocals) {
        this.saveToFileAndWriteComment(`FUNCTION ${functionName} ${numLocals}`, '');
        this.currentFunctionName = functionName;
        this.writeLabel(functionName);
        for (let i = 0; i < numLocals; i++) {
            this.writePushPop('push', 'constant', 0);
        }
    }

    writeReturn() {
        this.saveToFileAndWriteComment('RETURN', '');
        this.saveToFileAndWriteComment('frame = LCL', '@LCL\nD=M\n@frame\nM=D');
        this.saveToFileAndWriteComment('ret = *(frame - 5)', '@5\nA=D-A\nD=M\n@ret\nM=D');
        this.writePushPop('pop', 'argument', 0);
        this.saveToFileAndWriteComment('SP = ARG + 1', '@ARG\nD=M\n@SP\nM=D+1');
        this.saveToFileAndWriteComment('THAT = *(LCL - 1)', '@frame\nD=M\n@1\nA=D-A\nD=M\n@THAT\nM=D');
        this.saveToFileAndWriteComment('THIS = *(LCL - 2)', '@frame\nD=M\n@2\nA=D-A\nD=M\n@THIS\nM=D');
        this.saveToFileAndWriteComment('ARG = *(LCL - 3)', '@frame\nD=M\n@3\nA=D-A\nD=M\n@ARG\nM=D');
        this.saveToFileAndWriteComment('LCL = *(LCL - 4)', '@frame\nD=M\n@4\nA=D-A\nD=M\n@LCL\nM=D');
        this.saveToFileAndWriteComment('goto returnAddress', '@ret\nA=M\n0;JMP');
    }

    close() {
        fs.appendFileSync(this.outputFilePath, '');
    }
}

const Run = (folderPath, folderName) => {
    const files = fs.readdirSync(folderPath);
    const vmFiles = files.filter(file => file.endsWith('.vm'));
    const sysIndex = vmFiles.indexOf('Sys.vm');

    const outputPath = path.join(folderPath, `${folderName}.asm`);
    fs.writeFileSync(outputPath, '');
    const codeWriter = new CodeWriter(outputPath);

    for (const vmFile of vmFiles) {
        const inputPath = path.join(folderPath, vmFile);
        const parser = new Parser(inputPath);
        codeWriter.setInputFileName(path.basename(vmFile, '.vm'))
        if (sysIndex !== -1) {
            codeWriter.saveToFileAndWriteComment('bootstrap', '@256\nD=A\n@SP\nM=D');
            codeWriter.writeCall('Sys.init', 0);
        }
        while (parser.hasMoreLines()) {
            parser.advance();
            const commandType = parser.commandType();
            if (commandType === 'C_ARITHMETIC') {
                codeWriter.writeArithmetic(parser.arg1());
            } else if (commandType === 'C_PUSH' || commandType === 'C_POP') {
                codeWriter.writePushPop(commandType.toLowerCase().split('_')[1], parser.arg1(), parser.arg2());
            } else if (commandType === 'C_LABEL') {
                codeWriter.writeLabel(parser.arg1());
            } else if (commandType === 'C_GOTO') {
                codeWriter.writeGoto(parser.arg1());
            } else if (commandType === 'C_IF') {
                codeWriter.writeIf(parser.arg1());
            } else if (commandType === 'C_CALL') {
                codeWriter.writeCall(parser.arg1(), parser.arg2());
            } else if (commandType === 'C_FUNCTION') {
                codeWriter.writeFunction(parser.arg1(), parser.arg2());
            } else if (commandType === 'C_RETURN') {
                codeWriter.writeReturn();
            }
        }
        console.log(codeWriter.staticMappingNumber)
    }
    
    codeWriter.close();
}

// Main Logic
const main = () => {
    const allFiles = {
        '../7/MemoryAccess': [
            'BasicTest',
            'StaticTest',
            'PointerTest'
        ],
        '../7/StackArithmetic': [
            'SimpleAdd',
            'StackTest'
        ],
        'ProgramFlow': [
            'BasicLoop',
            'FibonacciSeries',
        ],
        'FunctionCalls': [
            'SimpleFunction',
            'NestedCall',
            'FibonacciElement',
            'StaticsTest'
        ]
    };

    for (const parentFolderName in allFiles) {
        allFiles[parentFolderName].forEach(folderName => {
            const folderPath = path.join('.', parentFolderName, folderName);
            Run(folderPath, folderName);
        });
    }
};

// Execute the Main Function
main();
