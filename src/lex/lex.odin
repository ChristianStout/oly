package lex

MAX_TOKEN_SIZE :: 256 // just an assumption, add more space if you need it

Token :: struct {
	type: string,
	lexeme: string,
	file_pos: int,
	lineno: int,
}

TokenRule :: struct {
	token_id: int,
	rule: proc(lexer: ^Lexer, p: string) -> bool
}

Lexer :: struct {
	curr_match: [MAX_TOKEN_SIZE]rune,	// The current unmatched string
	tokens: [dynamic]Token,				// OLY's own tokens (maybe able to be disabled by the user if they so choose)
	lineno: int,						// Line number
	pos: int, 							// Position in file
	criteria: proc(p: rune) -> bool	// When do we decide to loop through the rules? default is alpha-numeric
										// once criteria evaluates to false, then the lexer loops though the rules until it finds a match
}

is_alpha_numeric :: proc(char: rune) -> bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z') || (char >= '0' && char <= '9') || char == '_'
}

new_default :: proc(allocator := context.allocator) -> ^Lexer {
	lexer := new(Lexer, allocator)
	lexer.tokens = make([dynamic]Token, allocator)
	lexer.criteria = is_alpha_numeric

	return lexer
}

tokenize :: proc(lexer: ^Lexer, rules: []TokenRule, $T: typeid, allocator := context.allocator) -> []T {
	user_tokens := make([]T, allocator)

	return user_tokens
}
