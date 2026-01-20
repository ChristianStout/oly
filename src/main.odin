package oly

import "core:fmt"
import "core:strings"
import "lex"

CalcTokenId :: enum int {
	IGNORE,
	PLUS,
	MINUS,
	ASSIGN,
	EQUALS,
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

id_callback :: proc(lexer: ^lex.Lexer, token: ^lex.Token, p: string) {
	// Callbacks only get called after a token is successfully created.
	// It gives the lexer, token, and string in order to give the user
	// the ability to modify the token that is generated if so desired.
	fmt.printfln("Hello from id_callback : %v", p)
	cat := [?]string{p, "?"}
	new_p := strings.concatenate(cat[:])
	delete(p)
	token.lexeme = new_p
}

plus :: proc(p: string) -> bool {
	return p == "+"
}

minus :: proc(p: string) -> bool {
	return p == "-"
}

assign :: proc(p: string) -> bool {
	return p == "="
}

equals :: proc(p: string) -> bool {
	return p == "=="
}

colon :: proc(p: string) -> bool {
	return p == ":"
}

number :: proc(p: string) -> bool {
	for c in p {
		if !is_number(c) {
			return false
		}
	}
	return true
}

identifier :: proc(p: string) -> bool {
	for c, i in p {
		if i == 0 && !is_alpha(c) {
			return false
		}
		if !is_alpha(c) && !is_number(c) {
			return false
		}
	}

	return true
}

is_alpha :: proc(char: rune) -> bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z') || char == '_'
}

is_number :: proc(char: rune) -> bool {
	return char >= '0' && char <= '9'
}

unknown :: proc(p: string) -> bool {
	return len(p) == 1 // single char, this is the lowest precedant token
}

main :: proc() {
	rules := []^lex.TokenRule {
		lex.define_token(cast(int)CalcTokenId.PLUS, plus),
		lex.define_token(cast(int)CalcTokenId.MINUS, minus),
		lex.define_token(cast(int)CalcTokenId.ASSIGN, assign),
		lex.define_token(cast(int)CalcTokenId.EQUALS, equals),
		lex.define_token(cast(int)CalcTokenId.COLON, colon),
		lex.define_token(cast(int)CalcTokenId.NUMBER, number),
		lex.define_token(cast(int)CalcTokenId.IDENTIFIER, identifier, id_callback),
		lex.define_token(cast(int)CalcTokenId.UNKNOWN, unknown),
	}

	file := "32		= ==d+why +1-   42: "

	tokens, err := lex.tokenize(file, rules[:])
	if err != nil {
		fmt.println("ERROR OCCURED")
	}

	for token in tokens {
		fmt.printfln("Token : id: %v, lexeme: %s ", cast(CalcTokenId)token.id, token.lexeme)
	}

	for rule in rules {
		free(rule)
	}
}
