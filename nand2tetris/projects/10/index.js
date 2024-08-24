const fs = require('fs');
const path = require('path');

class JackTokenizer {
    constructor(inputFile) {
        this.inputFile = inputFile;
        this.allLines = fs.readFileSync(inputFile, 'utf-8').split('\n');
        this.cleanOneLine();
        this.currentIndex = 0;
        this.currentToken = '';
    }

    regexKeywords = /^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/;
    regexSymbols = /^([{}()\[\].,;+\-*/&|<>=~])$/;
    regexIntConst = /^(\d+)$/;
    regexStringConst = /^\"(.*)\"$/;
    regexIdentifier = /^([a-zA-Z_][a-zA-Z1-9_]*)$/;

    hasMoreTokens() {
        return this.currentIndex < this.oneLine.length;
    }

    advance() {
        let token = '';
        while (this.currentIndex < this.oneLine.length && this.oneLine[this.currentIndex] === ' ') {
            this.currentIndex++;
        }

        if (this.oneLine[this.currentIndex] === '"') {
            token = '"';
            this.currentIndex++;
            while (this.oneLine[this.currentIndex] !== '"') {
                token += this.oneLine[this.currentIndex];
                this.currentIndex++;
            }
            token += '"';
            this.currentIndex++;
        } else {
            while (this.currentIndex < this.oneLine.length && this.oneLine[this.currentIndex] !== ' ') {
                token += this.oneLine[this.currentIndex];
                this.currentIndex++;
            }
        }

        this.currentToken = token;
    }

    tokenType() {
        if (this.regexKeywords.test(this.currentToken)) {
            return 'KEYWORD';
        } else if (this.regexSymbols.test(this.currentToken)) {
            return 'SYMBOL';
        } else if (this.regexIntConst.test(this.currentToken)) {
            return 'INT_CONST';
        } else if (this.regexStringConst.test(this.currentToken)) {
            return 'STRING_CONST';
        } else if (this.regexIdentifier.test(this.currentToken)) {
            return 'IDENTIFIER';
        } else {
            return 'UNKNOWN';
        }
    }

    keyWord() {
        return this.currentToken;
    }

    symbol() {
        switch (this.currentToken) {
            case '<':
                return '&lt;';
            case '>':
                return '&gt;';
            case '&':
                return '&amp;';
            default:
                return this.currentToken;
        }
    }

    identifier() {
        return this.currentToken;
    }

    intVal() {
        return this.currentToken;
    }

    stringVal() {
        return this.currentToken.slice(1, this.currentToken.length - 1);
    }

    cleanOneLine() {
        this.oneLine = this.clearCommentsAndMakeOneLine(this.allLines);
        this.oneLine = this.createSpaceBetweenSymbols(this.oneLine);
        this.oneLine = this.onlyOneSpace(this.oneLine);
        this.oneLine = this.oneLine.trim();
    }

    clearCommentsAndMakeOneLine(allLines) {
        // Remove single-line comments (//)
        allLines = allLines.map(line => line.split('//')[0].trim());

        // Handle block comments (/* */)
        let commentIndex = [];
        for (let i = 0; i < allLines.length; i++) {
            for (let j = 0; j < allLines[i].length; j++) {
                if (allLines[i][j] === '/' && allLines[i][j + 1] === '*') {
                    commentIndex.push([i, j]);
                } else if (allLines[i][j] === '*' && allLines[i][j + 1] === '/') {
                    commentIndex.push([i, j + 1]);
                }
            }
        }

        for (let i = 0; i < commentIndex.length; i += 2) {
            const startLine = commentIndex[i][0];
            const startChar = commentIndex[i][1];
            const endLine = commentIndex[i + 1][0];
            const endChar = commentIndex[i + 1][1];

            if (startLine === endLine) {
                allLines[startLine] = allLines[startLine].slice(0, startChar) + allLines[startLine].slice(endChar + 1);
            } else {
                allLines[startLine] = allLines[startLine].slice(0, startChar);
                for (let j = startLine + 1; j < endLine; j++) {
                    allLines[j] = '';
                }
                allLines[endLine] = allLines[endLine].slice(endChar + 1);
            }
        }

        // Remove empty lines
        allLines = allLines.filter(line => line.length > 0);

        // Combine all lines into a single line
        return allLines.join(' ');
    }

    onlyOneSpace(oneLine) {
        return oneLine = oneLine.replace(/[\s]+/g, ' ');
    }

    createSpaceBetweenSymbols(oneLine) {
        return oneLine = oneLine.replace(/([{}()\[\].,;+\-*/&|<>=~])/g, ' $1 ');
    }
}

// Main function to run the tokenizer
const main = () => {
    const inputFolder = process.argv[2];
    if (!inputFolder) {
        console.error('Please provide a .jack file as input');
        return;
    }

    if (fs.lstatSync(inputFolder).isDirectory()) {
        const files = fs.readdirSync(inputFolder).filter(file => file.endsWith('.jack'));
        files.forEach(file => {
            const inputFile = path.join(inputFolder, file);
            console.log(`Processing ${inputFile}`);
            const tokenizer = new JackTokenizer(inputFile);
            const outputFile = inputFile.replace('.jack', 'FT.xml');
            fs.writeFileSync(outputFile, '');
            fs.appendFileSync(outputFile, '<tokens>\n');
            while (tokenizer.hasMoreTokens()) {
                tokenizer.advance();
                const tokenType = tokenizer.tokenType();
                if (tokenType === 'KEYWORD') {
                    fs.appendFileSync(outputFile, `<keyword> ${tokenizer.keyWord()} </keyword>\n`);
                } else if (tokenType === 'SYMBOL') {
                    fs.appendFileSync(outputFile, `<symbol> ${tokenizer.symbol()} </symbol>\n`);
                } else if (tokenType === 'IDENTIFIER') {
                    fs.appendFileSync(outputFile, `<identifier> ${tokenizer.identifier()} </identifier>\n`);
                } else if (tokenType === 'INT_CONST') {
                    fs.appendFileSync(outputFile, `<integerConstant> ${tokenizer.intVal()} </integerConstant>\n`);
                } else if (tokenType === 'STRING_CONST') {
                    fs.appendFileSync(outputFile, `<stringConstant> ${tokenizer.stringVal()} </stringConstant>\n`);
                } else {
                    console.error('Unknown token type');
                    return;
                }
            }
            fs.appendFileSync(outputFile, '</tokens>\n');
        });
        return;
    }
}

main();
