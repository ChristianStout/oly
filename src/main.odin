package oly

import "core:fmt"
import "core:strings"
import "lex"

CalcTokenId :: enum int {
	IGNORE,
	PLUS,
	MINUS,
	NUMBER,
	UNKNOWN,
}

CalcToken :: struct {
	lexeme: string,
	id: CalcTokenId,
	// ... any relavant information for your program
}

plus :: proc(lexer: ^lex.Lexer, p: string) -> bool {
	return p == "+"
}

minus :: proc(lexer: ^lex.Lexer, p: string) -> bool {
	return p == "-"
}

number :: proc(lexer: ^lex.Lexer, p:string) -> bool {
	return true
}

main :: proc() {
	lexer: ^lex.Lexer = lex.new_default()

	rules := [?]lex.TokenRule {
		lex.TokenRule { cast(int)CalcTokenId.PLUS, plus },
		lex.TokenRule { cast(int)CalcTokenId.PLUS, minus },
		lex.TokenRule { cast(int)CalcTokenId.PLUS, number },

	}


}
