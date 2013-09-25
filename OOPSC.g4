grammar OOPSC;

program      : classdecl;

classdecl    : 'CLASS' identifier 'IS'
                 memberdecl* 
                 'END CLASS';

memberdecl   : vardecl ';'
               | 'METHOD' identifier (':' identifier)? 'IS' methodbody;

vardecl      : identifier ( ',' identifier )* ':' identifier;

methodbody   : ( vardecl ';' )?
                 'BEGIN' statements
                 'END METHOD';

statements   :  statement* ;


                 
statement    : 'READ' memberaccess ';'
               | 'WRITE' expression ';'
               | 'RETURN' expression? ';'
               | 'IF' relation
                 'THEN' statements
                 ('ELSEIF' statements)*
                 ('ELSE' statements)?
                 'END IF'
               | 'WHILE' relation 
                 'DO' statements 
                 'END WHILE'
               | memberaccess ':=' expression ';'
               ;	

relation     : expression ( ( '=' | '#' | '<' | '>' | '<=' | '>=' ) expression )?
               |  'NOT' relation
               | relation ( 'AND' | 'OR' ) relation;

expression   : term ( ( '+' | '-' ) term )?;

term         : factor ( ( '*' | '/' | 'MOD' ) factor )*;

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