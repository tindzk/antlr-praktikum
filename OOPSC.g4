/* See also http://media.pragprog.com/titles/tpantlr2/code/tour/Java.g4 */
grammar OOPSC;

program
  : classDeclaration;

classDeclaration
  : 'CLASS' Identifier
    ('EXTENDS' Identifier)?
    'IS'
    memberDeclaration*
    'END CLASS'
  ;

memberDeclaration
  : variableDeclaration ';'
  | 'METHOD' Identifier
    ('(' variableDeclaration (';' variableDeclaration)* ')')?
    (':' Identifier)?
    'IS' methodBody
  ;

variableDeclaration
  : Identifier (',' Identifier)* ':' Identifier
  ;

methodBody
  : (variableDeclaration ';')*
    'BEGIN' statements
    'END METHOD'
  ;

statements
  : statement*
  ;

statement
  : 'READ' expression ';'
  | 'WRITE' expression ';'
  | 'RETURN' expression? ';'
  | 'THROW' expression ';'
  | 'IF' expression 'THEN' statements
    ('ELSEIF' expression 'THEN' statements)*
    ('ELSE' statements)?
    'END IF'
  | 'TRY' statements
    ('CATCH' literal 'DO' statements)+
    'END TRY'
  | 'WHILE' expression
    'DO' statements
    'END WHILE'
  | expression ':=' expression ';'
  | expression ';'
  ;

primaryExpression
  : '(' expression ')'
  | 'SELF'
  | literal
  | Identifier
  ;

expression
  : primaryExpression
  | expression '.' Identifier
  | '-' expression
  | 'NOT' expression
  | 'NEW' Identifier
  | expression '(' expressionList? ')'
  | expression ('*' | '/' | 'MOD') expression
  | expression ('+' | '-') expression
  | expression ('<=' | '>=' | '>' | '<') expression
  | expression 'AND' expression
  | expression 'OR' expression
  | expression
    ('='<assoc=right>
    |'#'<assoc=right>
    )
    expression
  ;

expressionList
  : expression (',' expression)*
  ;

literal
  : IntegerLiteral
  | CharacterLiteral
  | StringLiteral
  | 'NULL'
  ;

Identifier
  : LETTER (LETTER | DIGIT)*
  ;

IntegerLiteral
  : DIGIT+
  ;

DIGIT
  : [0-9]
  ;

LETTER
  : [a-zA-Z]
  ;

CharacterLiteral
  : '\'' (EscapeSequence | .?) '\''
  ;

StringLiteral
  : '\'' (EscapeSequence | ~('\\'|'\''))* '\''
  ;

fragment
EscapeSequence
  : '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
  ;

/* Match anything between { and }. */
COMMENT
  : '{' .*? '}' -> channel(HIDDEN)
  ;

LINE_COMMENT
  : '|' ~[\r\n]* '\r'? '\n' -> channel(HIDDEN)
  ;

/* Toss out whitespaces and newlines. */
WS
  : [ \t\n]+ -> skip
  ;
