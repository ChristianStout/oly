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
	rule: string,
	callback: proc(lexer: ^Lexer, token: ^Token, p: string) -> rawptr
}

Lexer :: struct {
	curr_match: [MAX_TOKEN_SIZE]rune,	// The current unmatched string
	tokens: [dynamic]Token,				// OLY's own tokens (maybe able to be disabled by the user if they so choose)
	lineno: int,						// Line number
	pos: int, 							// Position in file
}

LexerError :: enum {
	UnkownToken
}

new_default :: proc(allocator := context.allocator) -> ^Lexer {
	lexer := new(Lexer, allocator)
	lexer.tokens = make([dynamic]Token, allocator)

	return lexer
}

define_token :: proc(id: int, rule: string, callback: proc(lexer: ^Lexer, token: ^Token, p: string) -> rawptr = nil, allocator := context.allocator) -> ^TokenRule {
	token_rule := new(TokenRule, allocator)
	token_rule.token_id = id
	token_rule.rule = rule
	token_rule.callback = callback

	return token_rule
}

tokenize :: proc(rules: []TokenRule, lexer: ^Lexer = nil, allocator := context.allocator) -> ([]Token, ^LexerError) {
	if lexer == nil {
		lexer := new_default(allocator)
	}

	tokens := make([dynamic]Token)

	return tokens[:], nil
}
