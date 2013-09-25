grammar OOPSC;

program      : classdecl;

classdecl    : 'CLASS' identifier 'IS'
                 memberdecl* 
                 'END CLASS';

memberdecl   : vardecl ';'
             | 'METHOD' identifier
               ('(' vardecl ')')?
               (':' identifier)?
               'IS' methodbody
             ;

vardecl      : identifier ( ',' identifier )* ':' identifier;

methodbody   : ( vardecl ';' )?
                 'BEGIN' statements
                 'END METHOD';

statements   :  statement*;

statement    : 'READ' memberaccess ';'
               | 'WRITELN' evaluableExpression ';'
               | 'WRITE' evaluableExpression ';'
               | 'RETURN' evaluableExpression? ';'
               | 'IF' relation
                 'THEN' statements
                 ('ELSEIF' statements)*
                 ('ELSE' statements)?
                 'END IF'
               | 'WHILE' relation 
                 'DO' statements 
                 'END WHILE'
               | memberaccess ':=' evaluableExpression ';'
               | memberaccess '(' evaluableExpression ');'
               ;	

relation     :  'NOT' relation
               |  expression ( ( '=' | '#' | '<' | '>' | '<=' | '>=' ) expression )?
               |  relation 'AND' relation
               |  relation 'OR' relation;

evaluableExpression : '(' evaluableExpression ')'
                    | memberaccess '(' evaluableExpression ')'
                    | expression
                    ;

expression   : term ( ( '+' | '-' ) term )*
             | '(' expression ')'
             ;

term         : factor ( ( '*' | '/' | 'MOD' ) factor )*
             | StringLiteral
             ;

factor       : '-' factor
               | memberaccess
               ;

memberaccess : literal ( '.' varorcall )*;

literal      : number
               | character
               | 'NULL'
               | 'SELF'
               | 'NEW' identifier
               | '(' expression ')'
               | varorcall
               ;

// see http://media.pragprog.com/titles/tpantlr2/code/tour/Java.g4
StringLiteral
    :  '\'' ( EscapeSequence | ~('\\'|'\'') )* '\''
    ;

fragment
EscapeSequence
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    ;
  
varorcall    : identifier;

identifier   : LETTER ( LETTER | DIGIT )*;

number       : DIGIT+;

LETTER       : [a-zA-Z];

DIGIT        : [0-9];

character    : ''' (\n | \\ ) ''';

WS  :   [ \t\n]+ -> skip ; // toss out whitespaces and newlines

// see http://media.pragprog.com/titles/tpantlr2/code/tour/Java.g4
LINE_COMMENT
    : '|' ~[\r\n]* '\r'? '\n' -> channel(HIDDEN)
    ;
