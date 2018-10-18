%{
#include <map>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
using namespace std;
extern int yylex();
void yyerror(const char* s) {
    std::cerr << s << std::endl;
}

void print(double x) {
    std::cout << x;
}

void print(string x) {
    std::cout << x;
}

void println(double x) {
    std::cout << x << std::endl;
}

void println(string x) {
    std::cout << x << std::endl;
}

void print(vector<string> const& x) {
    for(auto it : x)
        print(it);
}

void println(vector<string> const& x) {
    print(x);
    std::cout << std::endl;
}

map<string,double> values;
%}


%union {
    int tok;
    double val;
    std::string* name;
    std::vector<std::string>* args;
}

%token <tok> EOL
%token <tok> ADD SUB MUL DIV POW
%token <tok> LP RP LB RB LCB RCB
%token <tok> EQ LT LE GT GE
%token <tok> DOT COMMA COLON SEMI_COLON WS
%token <tok> FOR IN TWO_DOTS SINGLE_QUOTE DOUBLE_QUOTE
%token <tok> FUNC_PRINT FUNC_PRINTLN

%token <name> ID
%token <name> STRING
%token <val> NUMBER

%type <val> expr
%type <val> func
%type <val> line
%type <val> operation
%type <val> assignment
%type <args> args

%start program

%left ADD SUB
%left MUL DIV
%left POW
%left LP RP

%%

program: /* empty */
    | line program
    | loop program

line: operation
    | func
    | assignment

operation: expr

args: expr { $$ = new vector<string>(1, std::to_string($1)); }
    | STRING { $$ = new vector<string>(1, $1->substr(1, int($1->size()) - 2)); delete $1; }
    | args COMMA expr { $1->emplace_back(std::to_string($3)); $$ = $1; }
    | args COMMA STRING { $1->emplace_back($3->substr(1, int($3->size()) - 2)); $$ = $1; delete $3; }

func: FUNC_PRINT LP args RP { print(*$3); delete $3; }
    | FUNC_PRINTLN LP args RP { println(*$3); delete $3; }
    | FUNC_PRINT LP expr RP { print($3); }
    | FUNC_PRINTLN LP expr RP { println($3); }
    | FUNC_PRINT LP STRING RP { print($3->substr(1, int($3->size()) - 2)); delete $3; }
    | FUNC_PRINTLN LP STRING RP { println($3->substr(1, int($3->size()) - 2)); delete $3; }

assignment: ID EQ expr { $$ = (values[*$1] = $3); }

loop: FOR ID IN NUMBER TWO_DOTS NUMBER LCB statements RCB

statements: 
    | line statements

expr: NUMBER { $$ = $1; }
    | ID {
            if(values.find(*$1) != values.end())
                $$ = values[*$1];
            else
                cerr << *$1 << " is not defined!!!" << endl;
            delete $1;
    }
    | assignment 
    | expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr { $$ = $1 / $3; }
    | expr POW expr { $$ = pow($1, $3); }
    | LP expr RP { $$ = $2; }
    | LB expr RB { $$ = $2; }
    | LCB expr RCB { $$ = $2; }

%%

int main() {
    while(yyparse() != 0);
    return 0;
}