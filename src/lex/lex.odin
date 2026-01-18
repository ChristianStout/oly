package lex

import "core:unicode/utf8"
import "core:fmt"

Token :: struct {
	id: int,
	lexeme: string,
	file_pos: int,
	lineno: int,
}

TokenRule :: struct {
	token_id: int,
	rule: proc(string) -> bool,
	callback: proc(lexer: ^Lexer, token: ^Token, p: string)
}

Lexer :: struct {
	curr_str: [dynamic]rune,			// The current unmatched string
	tokens: [dynamic]Token,				// OLY's own tokens (maybe able to be disabled by the user if they so choose)
	file_pos: int, 						// Position in file
	lineno: int,						// Line number
}

LexerError :: enum {
	None,
	TokenRuleWithoutRuleFunction,
	UnkownToken
}

new_default :: proc(allocator := context.allocator) -> ^Lexer {
	lexer := new(Lexer, allocator)
	lexer.tokens = make([dynamic]Token, allocator)
	lexer.curr_str = make([dynamic]rune, allocator)
	lexer.lineno = 1

	return lexer
}

delete_lexer :: proc(lexer: ^Lexer) {
	delete(lexer.tokens)
	delete(lexer.curr_str)
	free(lexer)
}

define_token :: proc(
	id: int,
	rule: proc(string) -> bool,
	callback: proc(lexer: ^Lexer, token: ^Token, p: string) = nil,
	allocator := context.allocator
) -> ^TokenRule {
	//TODO: Handle nil rule
	token_rule := new(TokenRule, allocator)
	token_rule.token_id = id
	token_rule.rule = rule
	token_rule.callback = callback

	return token_rule
}

find_first_match_index :: proc(s: string, rules: []^TokenRule) -> int {
	for rule, i in rules {
		if rule.rule(s) {
			return i
		}
	}
	return -1
}

is_ignore :: proc(r: rune, ignore: []rune) -> bool {
	for i in ignore {
		if r == i {
			return true
		}
	}
	return false
}

tokenize :: proc(
	file: string,
	rules: []^TokenRule,
	ignore: []rune = []rune{' ', '\n', '\t'},
	lexer: ^Lexer = nil,
	allocator := context.allocator
) -> ([]^Token, LexerError) {
	lexer := lexer
	if lexer == nil {
		lexer = new_default(allocator)
	}
	defer free(lexer)

	tokens := make([dynamic]^Token)
	curr_str := lexer.curr_str
	prev_match_index := -1
	prev_lexeme := ""
	prev_lineno := 0

	for r in file {
		token_generated := false
		ignore_r := is_ignore(r, ignore)
		lexer.file_pos += 1
		if r == '\n' {
			lexer.lineno += 1 
		}

		lexeme: string
		match_index := -1
		if !ignore_r {
			append(&curr_str, r)

			lexeme = utf8.runes_to_string(curr_str[:], allocator)
			match_index = find_first_match_index(lexeme, rules)
		}
	
		if match_index == -1 && prev_match_index >= 0 {
			token_generated = true
			token := new(Token)
			token.id = rules[prev_match_index].token_id
			token.lexeme = prev_lexeme
			token.file_pos = lexer.file_pos - 1
			token.lineno = prev_lineno

			callback := rules[prev_match_index].callback
			if callback != nil {
				callback(lexer, token, prev_lexeme)
			}

			append(&tokens, token)

			clear(&curr_str)
			if !ignore_r {
				append(&curr_str, r)
				delete(lexeme)
				lexeme = utf8.runes_to_string(curr_str[:], allocator)
				match_index = find_first_match_index(lexeme, rules)
			}
		}	
		
		// if match_index == -1 && prev_match_index == -1 {
		// 	return nil, .UnkownToken
		// }

		// if ingore_r {

		// }

		fmt.println("curr_str : ", lexeme, ", token_generated : ", token_generated)
		
		if !token_generated {
			delete(prev_lexeme)
		}	
		prev_lexeme = lexeme
		prev_match_index = match_index
		prev_lineno = lexer.lineno
	}

	return tokens[:], .None
}
