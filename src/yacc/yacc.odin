package yacc

import "../lex"

Parser :: struct {

}

ParseRule :: struct {
	name: string,
	rule: []string,
	func: proc([]string) -> rawptr
}

define_rule("expr", []string{"expr", "MINUS", "epxr"}, binary_expr)
define_rule("expr", []string{"IDENTIFIER"}, id_expr)

parse :: proc(tokens: []^lex.Tokens, token_type: typeid, rules: []ParseRule) -> rawptr {

}
