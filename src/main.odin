package oly

import "core:fmt"
import "core:strings"
import "lex"

CalcTokenId :: enum int {
	IGNORE,
	PLUS,
	MINUS,
	ASSIGN,
	COLON,
	NUMBER,
	IDENTIFIER,
	UNKNOWN,
}

CalcToken :: struct {
	lexeme: string,
	id: CalcTokenId,
	// ... any relavant information for your program
}

id_callback :: proc(lexer: ^lex.Lexer, token: ^lex.Token, p: string) -> rawptr {
	fmt.println("Hello from id_callback : %v", p)

	return nil
}


main :: proc() {
	rules := [?]^lex.TokenRule {
		lex.define_token(cast(int)CalcTokenId.PLUS, "+"),
		lex.define_token(cast(int)CalcTokenId.MINUS, "-"),
		lex.define_token(cast(int)CalcTokenId.ASSIGN, "="),
		lex.define_token(cast(int)CalcTokenId.COLON, ":"),
		lex.define_token(cast(int)CalcTokenId.NUMBER, "[0-9]+"),
		lex.define_token(cast(int)CalcTokenId.IDENTIFIER, "[_a-zA-Z][_a-zA-Z0-9]*", id_callback),
		lex.define_token(cast(int)CalcTokenId.UNKNOWN, "."),
	}

}
