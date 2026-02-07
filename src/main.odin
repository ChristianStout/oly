package oly

import "core:fmt"
import "lex"

TokenID :: enum int {
	A,
	B,
}

a :: proc(p: string) -> bool {
	return p == "a"
}

b :: proc(p: string) -> bool {
	return p == "b"
}

main :: proc() {
	rules := []^lex.TokenRule {
		lex.define_token(cast(int)TokenID.A, a),
		lex.define_token(cast(int)TokenID.B, b)
	}

	file := "aabb"

	tokens, err := lex.tokenize(file, rules[:])
	if err != nil {
		fmt.println("ERROR OCCURED")
	}

	for token in tokens {
		fmt.printfln("Token : id: %v, lexeme: %s ", cast(TokenID)token.id, token.lexeme)
	}

	for rule in rules {
		free(rule)
	}
}
