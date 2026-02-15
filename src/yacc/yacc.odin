package yacc

import "core:reflect"
import "core:fmt"
import "../lex"

// Parser :: struct {
//     token_stack: [dynamic]string, // ID for the terminal value
// 	parse_table: ParseTable,
// 	precedence: []string,
// }
//
// ParseTable :: struct {
// 	first: string,
// 	follow: [dynamic]string,
// }

ParseRule :: struct {
	name: string,
	rule: []string,
	func: proc([]string) -> rawptr
}

define_rule :: proc(name: string, rule: []string, func: proc([]string) -> rawptr, allocator := context.allocator) -> ^ParseRule {
	parse_rule := new(ParseRule, allocator)
	parse_rule.name = name
	parse_rule.rule = rule
	parse_rule.func = func
	return parse_rule
}

build_table :: proc(tokens: []^lex.Token, token_type: typeid, rules: []ParseRule, allocator := context.allocator) -> ^ParseTable {
	table := new(ParseTable, allocator)

	token_names := reflect.enum_field_names(token_type)
    for name in token_names {
        fmt.println("Token Name: ", name)
    }

	return table
}

parse :: proc(tokens: []^lex.Token, token_type: typeid, rules: []ParseRule, precedence: []string) -> rawptr {
	parser: Parser
	parser.precedence = precedence

	table := build_table(tokens, token_type, rules)

  return nil
}
