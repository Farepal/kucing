const fs = require('fs');
const path = require('path');
let aCount = 0;
let staticMemoryNumber = 16;
const staticMappingNumber = { };

const Parser = (inputFilePath, outputFilePath) => {
    const trim = (line) => line.trim();

    const removeComments = (line) => {
        const pos = line.indexOf('//');
        return pos !== -1 ? line.substring(0, pos) : line;
    };

    const cleanLine = (line) => trim(removeComments(line));

    const isCommand = (line) => line.length > 0;

    const commandType = (line) => {
        const firstWord = line.split(' ')[0];
        const commandTypes = {
            'push': 'C_PUSH',
            'pop': 'C_POP',
            'label': 'C_LABEL',
            'goto': 'C_GOTO',
            'if-goto': 'C_IF',
            'function': 'C_FUNCTION',
            'return': 'C_RETURN',
            'call': 'C_CALL'
        };
        return commandTypes[firstWord] || 'C_ARITHMETIC';
    };

    const advance = (line) => {
        if (isCommand(line)) {
            const type = commandType(line);
            switch (type) {
                case 'C_ARITHMETIC':
                    writeArithmetic(line);
                    break;
                case 'C_PUSH':
                    writePushPop('push', line.split(' ')[1], line.split(' ')[2]);
                    break;
                case 'C_POP':
                    writePushPop('pop', line.split(' ')[1], line.split(' ')[2]);
                    break;
                default:
                    break;
            }
        }

        function writeArithmetic(command) {
            const template = {
                'add': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M+D',
                'sub': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M-D',
                'neg': '@SP\nA=M-1\nM=-M',
                'eq': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${aCount}\nD;JEQ\n@SP\nA=M-1\nM=0\n@CONTINUE${aCount}\n0;JMP\n(TRUE${aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${aCount})`,
                'gt': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${aCount}\nD;JGT\n@SP\nA=M-1\nM=0\n@CONTINUE${aCount}\n0;JMP\n(TRUE${aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${aCount})`,
                'lt': `@SP\nM=M-1\nA=M\nD=M\nA=A-1\nD=M-D\n@TRUE${aCount}\nD;JLT\n@SP\nA=M-1\nM=0\n@CONTINUE${aCount}\n0;JMP\n(TRUE${aCount})\n@SP\nA=M-1\nM=-1\n(CONTINUE${aCount})`,
                'and': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M&D',
                'or': '@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=M|D',
                'not': '@SP\nA=M-1\nM=!M'
            };
            aCount++;
            fs.appendFileSync(outputFilePath, template[command] + '\n');
        }

        function writePushPop(command, segment, index) {
            const fileName = inputFilePath.split('/').pop().split('.')[0];
            const staticLabel = `${fileName}.${index}`;
            if (segment === 'static') {
                if (!staticMappingNumber[staticLabel]) {
                    staticMappingNumber[staticLabel] = staticMemoryNumber;
                    staticMemoryNumber++;
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
                    'static': `@${staticMappingNumber[staticLabel]}\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1`,
                };
                fs.appendFileSync(outputFilePath, templatePush[segment] + '\n');
            } else if (command === 'pop') {
                const templatePop = {
                    'local': `@${index}\nD=A\n@LCL\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'argument': `@${index}\nD=A\n@ARG\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'this': `@${index}\nD=A\n@THIS\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'that': `@${index}\nD=A\n@THAT\nD=D+M\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'temp': `@${index}\nD=A\n@5\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'pointer': `@${index}\nD=A\n@3\nD=D+A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                    'static': `@${staticMappingNumber[staticLabel]}\nD=A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D`,
                };

                fs.appendFileSync(outputFilePath, templatePop[segment] + '\n');
            }
        }
    };

    const pass = () => {
        const lines = fs.readFileSync(inputFilePath, 'utf-8').split('\n');
        lines.forEach(line => {
            const cleanedLine = cleanLine(line);
            advance(cleanedLine);
        });
    };

    return {
        pass
    };
};

const main = () => {
    const allFile = {
        'MemoryAccess': [
            'BasicTest',
            'StaticTest',
            'PointerTest'
        ],
        'StackArithmetic': [
            'SimpleAdd',
            'StackTest'
        ]
    }

    let folderName = 'MemoryAccess';
    for (let i = 0; i < allFile[folderName].length; i++) {
        const inputPath = path.join('.', folderName, allFile[folderName][i], `${allFile[folderName][i]}.vm`);
        const outputPath = path.join('.', folderName, allFile[folderName][i], `${allFile[folderName][i]}.asm`);
        fs.writeFileSync(outputPath, '');
        const parser = Parser(inputPath, outputPath);
        parser.pass();
    }

    folderName = 'StackArithmetic';
    for (let i = 0; i < allFile[folderName].length; i++) {
        const inputPath = path.join('.', folderName, allFile[folderName][i], `${allFile[folderName][i]}.vm`);
        const outputPath = path.join('.', folderName, allFile[folderName][i], `${allFile[folderName][i]}.asm`);
        fs.writeFileSync(outputPath, '');
        const parser = Parser(inputPath, outputPath);
        parser.pass();
    }
};

main();