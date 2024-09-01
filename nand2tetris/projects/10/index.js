const fs = require("fs");
const path = require("path");

class JackTokenizer {
  constructor(inputFile) {
    this.inputFile = inputFile;
    this.allLines = fs.readFileSync(inputFile, "utf-8").split("\n");
    this.cleanOneLine();
    this.currentIndex = 0;
    this.currentToken = "";
  }

  regexKeywords =
    /^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/;
  regexSymbols = /^([{}()\[\].,;+\-*/&|<>=~])$/;
  regexIntConst = /^(\d+)$/;
  regexStringConst = /^\"(.*)\"$/;
  regexIdentifier = /^([a-zA-Z_][a-zA-Z1-9_]*)$/;

  hasMoreTokens() {
    return this.currentIndex < this.oneLine.length;
  }

  advance() {
    let token = "";
    while (
      this.currentIndex < this.oneLine.length &&
      this.oneLine[this.currentIndex] === " "
    ) {
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
      while (
        this.currentIndex < this.oneLine.length &&
        this.oneLine[this.currentIndex] !== " "
      ) {
        token += this.oneLine[this.currentIndex];
        this.currentIndex++;
      }
    }

    this.currentToken = token;
  }

  tokenType() {
    if (this.regexKeywords.test(this.currentToken)) {
      return "KEYWORD";
    } else if (this.regexSymbols.test(this.currentToken)) {
      return "SYMBOL";
    } else if (this.regexIntConst.test(this.currentToken)) {
      return "INT_CONST";
    } else if (this.regexStringConst.test(this.currentToken)) {
      return "STRING_CONST";
    } else if (this.regexIdentifier.test(this.currentToken)) {
      return "IDENTIFIER";
    } else {
      return "UNKNOWN";
    }
  }

  keyWord() {
    return this.currentToken;
  }

  symbol() {
    switch (this.currentToken) {
      case "<":
        return "&lt;";
      case ">":
        return "&gt;";
      case "&":
        return "&amp;";
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
    allLines = allLines.map((line) => line.split("//")[0].trim());

    // Handle block comments (/* */)
    let commentIndex = [];
    for (let i = 0; i < allLines.length; i++) {
      for (let j = 0; j < allLines[i].length; j++) {
        if (allLines[i][j] === "/" && allLines[i][j + 1] === "*") {
          commentIndex.push([i, j]);
        } else if (allLines[i][j] === "*" && allLines[i][j + 1] === "/") {
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
        allLines[startLine] =
          allLines[startLine].slice(0, startChar) +
          allLines[startLine].slice(endChar + 1);
      } else {
        allLines[startLine] = allLines[startLine].slice(0, startChar);
        for (let j = startLine + 1; j < endLine; j++) {
          allLines[j] = "";
        }
        allLines[endLine] = allLines[endLine].slice(endChar + 1);
      }
    }

    // Remove empty lines
    allLines = allLines.filter((line) => line.length > 0);

    // Combine all lines into a single line
    return allLines.join(" ");
  }

  onlyOneSpace(oneLine) {
    return (oneLine = oneLine.replace(/[\s]+/g, " "));
  }

  createSpaceBetweenSymbols(oneLine) {
    return (oneLine = oneLine.replace(/([{}()\[\].,;+\-*/&|<>=~])/g, " $1 "));
  }
}

class CompilationEngine {
  constructor(inputFile) {
    this.inputFile = inputFile;
    this.allLines = fs.readFileSync(inputFile, "utf-8").split("\n");
    this.outputFile = inputFile.replace("FT.xml", "R.xml");
    fs.writeFileSync(this.outputFile, "");
    this.currentIndex = 0;
    this.numberOfTabs = 0;
  }

  writeCompilationEngine(content) {
    const tabs = "  ".repeat(this.numberOfTabs);
    fs.appendFileSync(this.outputFile, `${tabs}${content}\n`);
  }

  currentToken() {
    return this.allLines[this.currentIndex];
  }

  toTheNextToken() {
    this.currentIndex++;
    return this.allLines[this.currentIndex];
  }

  lookAheadToken(content) {
    const nextToken = this.allLines[this.currentIndex + 1];
    return nextToken.includes(content);
  }

  writeNonTerminalStart(tagName) {
    this.writeCompilationEngine(tagName);
    this.numberOfTabs++;
  }

  writeNonTerminalEnd(tagName) {
    this.numberOfTabs--;
    this.writeCompilationEngine(tagName);
  }

  isNextStatement() {
    return (
      this.lookAheadToken('let') ||
      this.lookAheadToken('if') ||
      this.lookAheadToken('while') ||
      this.lookAheadToken('do') ||
      this.lookAheadToken('return')
    );
  }

  isNextOperator() {
    return (
      (this.lookAheadToken('+') ||
        this.lookAheadToken('-') ||
        this.lookAheadToken('*') ||
        this.lookAheadToken('<symbol> / </symbol>') ||
        this.lookAheadToken('=') ||
        this.lookAheadToken('|') ||
        this.lookAheadToken('&amp') ||
        this.lookAheadToken('&lt') ||
        this.lookAheadToken('&gt'))
    );
  }

  isNextUnaryOperator() {
    return this.lookAheadToken('-') || this.lookAheadToken('~');
  }

  isNextKeywordConstant() {
    return (
      this.lookAheadToken('true') ||
      this.lookAheadToken('false') ||
      this.lookAheadToken('null') ||
      this.lookAheadToken('this')
    );
  }

  parse() {
    this.complieClass();
  }

  complieClass() {
    this.writeNonTerminalStart("<class>");
    this.writeCompilationEngine(this.toTheNextToken()); // class
    this.writeCompilationEngine(this.toTheNextToken()); // className
    this.writeCompilationEngine(this.toTheNextToken()); // {
    while (this.lookAheadToken('static') || this.lookAheadToken('field')) {
      this.compileClassVarDec();
    }
    while (
      this.lookAheadToken('constructor') ||
      this.lookAheadToken('function') ||
      this.lookAheadToken('method')
    ) {
      this.compileSubroutine();
    }
    this.writeCompilationEngine(this.toTheNextToken()); // }
    this.writeNonTerminalEnd("</class>");
  }

  compileClassVarDec() {
    this.writeNonTerminalStart("<classVarDec>");
    this.writeCompilationEngine(this.toTheNextToken()); // static or field
    this.writeCompilationEngine(this.toTheNextToken()); // type
    this.writeCompilationEngine(this.toTheNextToken()); // varName
    while (this.lookAheadToken(',')) {
      this.writeCompilationEngine(this.toTheNextToken()); // ,
      this.writeCompilationEngine(this.toTheNextToken()); // varName
    }
    this.writeCompilationEngine(this.toTheNextToken()); // ;
    this.writeNonTerminalEnd("</classVarDec>");
  }

  compileSubroutine() {
    this.writeNonTerminalStart("<subroutineDec>");
    this.writeCompilationEngine(this.toTheNextToken()); // constructor or function or method
    this.writeCompilationEngine(this.toTheNextToken()); // void or type
    this.writeCompilationEngine(this.toTheNextToken()); // subroutineName
    this.writeCompilationEngine(this.toTheNextToken()); // (
    this.compileParameterList();
    this.writeCompilationEngine(this.toTheNextToken()); // )
    this.compileSubroutineBody();
    this.writeNonTerminalEnd("</subroutineDec>");
  }

  compileParameterList() {
    this.writeNonTerminalStart("<parameterList>");
    if (!this.lookAheadToken(')')) {
      this.writeCompilationEngine(this.toTheNextToken()); // type
      this.writeCompilationEngine(this.toTheNextToken()); // varName
      while (this.lookAheadToken(',')) {
        this.writeCompilationEngine(this.toTheNextToken()); // ,
        this.writeCompilationEngine(this.toTheNextToken()); // type
        this.writeCompilationEngine(this.toTheNextToken()); // varName
      }
    }
    this.writeNonTerminalEnd("</parameterList>");
  }

  compileSubroutineBody() {
    this.writeNonTerminalStart("<subroutineBody>");
    this.writeCompilationEngine(this.toTheNextToken()); // {
    while (this.lookAheadToken('var')) {
      this.compileVarDec();
    }
    while (this.isNextStatement()) {
      this.compileStatements();
    }
    this.writeCompilationEngine(this.toTheNextToken()); // }
    this.writeNonTerminalEnd("</subroutineBody>");
  }

  compileVarDec() {
    this.writeNonTerminalStart("<varDec>");
    this.writeCompilationEngine(this.toTheNextToken()); // var
    this.writeCompilationEngine(this.toTheNextToken()); // type
    this.writeCompilationEngine(this.toTheNextToken()); // varName
    while (this.lookAheadToken(',')) {
      this.writeCompilationEngine(this.toTheNextToken()); // ,
      this.writeCompilationEngine(this.toTheNextToken()); // varName
    }
    this.writeCompilationEngine(this.toTheNextToken()); // ;
    this.writeNonTerminalEnd("</varDec>");
  }

  compileStatements() {
    this.writeNonTerminalStart("<statements>");
    while (this.isNextStatement()) {
      if (this.lookAheadToken('let')) {
        this.compileLet();
      } else if (this.lookAheadToken('if')) {
        this.compileIf();
      } else if (this.lookAheadToken('while')) {
        this.compileWhile();
      } else if (this.lookAheadToken('do')) {
        this.compileDo();
      } else if (this.lookAheadToken('return')) {
        this.compileReturn();
      }
    }
    this.writeNonTerminalEnd("</statements>");
  }

  compileLet() {
    this.writeNonTerminalStart("<letStatement>");
    this.writeCompilationEngine(this.toTheNextToken()); // let
    this.writeCompilationEngine(this.toTheNextToken()); // varName
    if (this.lookAheadToken('[')) {
      this.writeCompilationEngine(this.toTheNextToken()); // [
      this.compileExpression();
      this.writeCompilationEngine(this.toTheNextToken()); // ]
    }
    this.writeCompilationEngine(this.toTheNextToken()); // =
    this.compileExpression();
    this.writeCompilationEngine(this.toTheNextToken()); // ;
    this.writeNonTerminalEnd("</letStatement>");
  }

  compileIf() {
    this.writeNonTerminalStart("<ifStatement>");
    this.writeCompilationEngine(this.toTheNextToken()); // if
    this.writeCompilationEngine(this.toTheNextToken()); // (
    this.compileExpression();
    this.writeCompilationEngine(this.toTheNextToken()); // )
    this.writeCompilationEngine(this.toTheNextToken()); // {
    this.compileStatements();
    while (this.isNextStatement()) {
      this.compileStatements();
    }
    this.writeCompilationEngine(this.toTheNextToken()); // }
    if (this.lookAheadToken('else')) {
      this.writeCompilationEngine(this.toTheNextToken()); // else
      this.writeCompilationEngine(this.toTheNextToken()); // {
      this.compileStatements();
      while (this.isNextStatement()) {
        this.compileStatements();
      }
      this.writeCompilationEngine(this.toTheNextToken()); // }
    }
    this.writeNonTerminalEnd("</ifStatement>");
  }

  compileWhile() {
    this.writeNonTerminalStart("<whileStatement>");
    this.writeCompilationEngine(this.toTheNextToken()); // while
    this.writeCompilationEngine(this.toTheNextToken()); // (
    this.compileExpression();
    this.writeCompilationEngine(this.toTheNextToken()); // )
    this.writeCompilationEngine(this.toTheNextToken()); // {
    this.compileStatements();
    while (this.isNextStatement()) {
      this.compileStatements();
    }
    this.writeCompilationEngine(this.toTheNextToken()); // }
    this.writeNonTerminalEnd("</whileStatement>");
  }

  compileDo() {
    this.writeNonTerminalStart("<doStatement>");
    this.writeCompilationEngine(this.toTheNextToken()); // do
    this.writeCompilationEngine(this.toTheNextToken()); // className
    while (this.lookAheadToken('.') || this.lookAheadToken('(')) {
      if (this.lookAheadToken('.')) {
        this.writeCompilationEngine(this.toTheNextToken()); // .
        this.writeCompilationEngine(this.toTheNextToken()); // subroutineName
        this.writeCompilationEngine(this.toTheNextToken()); // (
        this.compileExpressionList();
        this.writeCompilationEngine(this.toTheNextToken()); // )
      } else if (this.lookAheadToken('(')) {
        this.writeCompilationEngine(this.toTheNextToken()); // (
        this.compileExpressionList();
        this.writeCompilationEngine(this.toTheNextToken()); // )
      }
    }
    this.writeCompilationEngine(this.toTheNextToken()); // ;
    this.writeNonTerminalEnd("</doStatement>");
  }

  compileReturn() {
    this.writeNonTerminalStart("<returnStatement>");
    this.writeCompilationEngine(this.toTheNextToken()); // return
    if (!this.lookAheadToken(';')) {
      this.compileExpression();
    }
    this.writeCompilationEngine(this.toTheNextToken()); // ;
    this.writeNonTerminalEnd("</returnStatement>");
  }

  compileExpression() {
    this.writeNonTerminalStart("<expression>");
    this.compileTerm();
    while (this.isNextOperator()) {
      this.writeCompilationEngine(this.toTheNextToken()); // op
      this.compileTerm();
    }
    this.writeNonTerminalEnd("</expression>");
  }

  compileTerm() {
    this.writeNonTerminalStart("<term>");
    if (
      this.lookAheadToken('integerConstant') ||
      this.lookAheadToken('stringConstant') ||
      this.isNextKeywordConstant()
    ) {
      this.writeCompilationEngine(this.toTheNextToken()); // integerConstant or stringConstant or keyword
    } else if (this.lookAheadToken('identifier')) {
      this.writeCompilationEngine(this.toTheNextToken()); // varName
      if (this.lookAheadToken('[')) {
        this.writeCompilationEngine(this.toTheNextToken()); // [
        this.compileExpression();
        this.writeCompilationEngine(this.toTheNextToken()); // ]
      } else if (this.lookAheadToken('.')) {
        this.writeCompilationEngine(this.toTheNextToken()); // .
        this.writeCompilationEngine(this.toTheNextToken()); // subroutineName
        this.writeCompilationEngine(this.toTheNextToken()); // (
        this.compileExpressionList();
        this.writeCompilationEngine(this.toTheNextToken()); // )
      } else if (this.lookAheadToken('(')) {
        this.writeCompilationEngine(this.toTheNextToken()); // (
        this.compileExpressionList();
        this.writeCompilationEngine(this.toTheNextToken()); // )
      }
    } else if (this.isNextUnaryOperator()) {
      this.writeCompilationEngine(this.toTheNextToken()); // unaryOp
      this.compileTerm();
    } else if (this.lookAheadToken('(')) {
      this.writeCompilationEngine(this.toTheNextToken()); // (
      this.compileExpression();
      this.writeCompilationEngine(this.toTheNextToken()); // )
    }
    this.writeNonTerminalEnd("</term>");
  }

  compileExpressionList() {
    this.writeNonTerminalStart("<expressionList>");
    if (!this.lookAheadToken(')')) {
      this.compileExpression();
      while (this.lookAheadToken(',')) {
        this.writeCompilationEngine(this.toTheNextToken()); // ,
        this.compileExpression();
      }
    }
    this.writeNonTerminalEnd("</expressionList>");
  }
}

class jackAnalyzer {
  constructor(inputFolderOrFile) {
    this.inputFolderOrFile = inputFolderOrFile;
    if (inputFolderOrFile.endsWith(".jack")) {
      this.inputFolderOrFile = path.dirname(inputFolderOrFile);
      this.files = [path.basename(inputFolderOrFile)];
    } else {
      this.files = fs
        .readdirSync(inputFolderOrFile)
        .filter((file) => file.endsWith(".jack"));
    }
  }

  parse() {
    this.files.forEach((file) => {
      const fileName = path.join(this.inputFolderOrFile, file);
      this.parseFileToFTxml(fileName);
      const FTxmlFile = fileName.replace(".jack", "FT.xml");
      this.parseFTxmlToXML(FTxmlFile);
    });
  }

  parseFileToFTxml(fileName) {
    const tokenizer = new JackTokenizer(fileName);
    const outputFile = fileName.replace(".jack", "FT.xml");
    fs.writeFileSync(outputFile, "");
    fs.appendFileSync(outputFile, "<tokens>\n");
    while (tokenizer.hasMoreTokens()) {
      tokenizer.advance();
      const tokenType = tokenizer.tokenType();
      if (tokenType === "KEYWORD") {
        fs.appendFileSync(
          outputFile,
          `<keyword> ${tokenizer.keyWord()} </keyword>\n`
        );
      } else if (tokenType === "SYMBOL") {
        fs.appendFileSync(
          outputFile,
          `<symbol> ${tokenizer.symbol()} </symbol>\n`
        );
      } else if (tokenType === "IDENTIFIER") {
        fs.appendFileSync(
          outputFile,
          `<identifier> ${tokenizer.identifier()} </identifier>\n`
        );
      } else if (tokenType === "INT_CONST") {
        fs.appendFileSync(
          outputFile,
          `<integerConstant> ${tokenizer.intVal()} </integerConstant>\n`
        );
      } else if (tokenType === "STRING_CONST") {
        fs.appendFileSync(
          outputFile,
          `<stringConstant> ${tokenizer.stringVal()} </stringConstant>\n`
        );
      } else {
        console.error("Unknown token type");
        return;
      }
    }
    fs.appendFileSync(outputFile, "</tokens>\n");
  }

  parseFTxmlToXML(FTxmlFile) {
    const compilationEngine = new CompilationEngine(FTxmlFile);
    compilationEngine.parse();
  }
}

// Main function to run the tokenizer
const main = () => {
  const inputFolder = process.argv[2];
  const analyzer = new jackAnalyzer(inputFolder);
  analyzer.parse();
};

main();
