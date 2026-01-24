package yacc

import "../lex"

Parser :: struct {
    token_stack: [dynamic]string, // ID for the terminal value
	parse_table: ParseTable,
	precedence: []string,
}

ParseTable :: struct {
	first: string,
	follow: [dynamic]string,
}

ParseRule :: struct {
	name: string,
	rule: []string,
	func: proc([]string) -> rawptr
}

define_rule :: proc(name: string, rule: []string, func: proc([]string) -> rawptr) -> ParserRule {
	parser_rule := Parser {
		name: name,
		rule: rule,
		func: func,
	}
	return parser_rule
}

build_table(tokens: []^lex.Tokens, token_type: typeid, rules: []ParseRules) -> ParseTable {
	table: ParseTable

	return table
}

parse :: proc(tokens: []^lex.Tokens, token_type: typeid, rules: []ParseRule, precedence: []string) -> rawptr {
	parser: Parser
	parser.precedence = precedence

	table = build_table(tokens, token_type, rules)


}
