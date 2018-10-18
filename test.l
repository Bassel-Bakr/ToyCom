%{   
#include <string>
#include <vector>
#include "test.hpp"
%}

%option noyywrap

%%

".." { return TWO_DOTS; }
"in" { return IN; }
"for" { return FOR; }
"print" { return FUNC_PRINT; }
"println" { return FUNC_PRINTLN; }

[_$a-zA-Z][_$a-zA-Z0-9]* {
        yylval.name = new std::string(yytext);
        return ID;
    }

[-+]?([0-9])+([0-9]+)? {
        yylval.val = std::stof(yytext);
        return NUMBER;
    }

\' { return SINGLE_QUOTE; }
\" { return DOUBLE_QUOTE; }

["][^"]*?["] {
        yylval.name = new std::string(yytext);
        return STRING;
    }

"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"^" { return POW; }

"=" { return EQ; }
"<" { return LT; }
">" { return GT; }
"<=" { return LE; }
">=" { return GE; }

"(" { return LP; }
")" { return RP; }
"[" { return LB; }
"]" { return RB; }
"{" { return LCB; }
"}" { return RCB; }

"." { return DOT; }
"," { return COMMA; }
":" { return COLON; }
";" { return SEMI_COLON; }

[ \r\n\t]* /* ignore white spaces */

%%