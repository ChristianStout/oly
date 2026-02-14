package yacc

/*
The parser assumes that we have a list of rules which contain:
	Left hand side (non-terminal)	:= X
	Right hand side (rule) 		:= Y

which translates to X -> Y

*/

GrammarRule :: struct {
	left: string,
	right: []string,
	reduce_call: proc([]rawptr) -> rawptr,
}

ParseTable :: struct {
	firsts: map[string][dynamic]string,
	follows: map[string][dynamic]string,
	token_names: []string,
	var_names: ^[dynamic]string,
}

Parser :: struct {
	table: ^ParseTable,
	rules: []GrammarRules,
}

calculate_firsts :: proc(parser: ^Parser) {
	for rule in parser.rules {
		if !rule.left in parser.table.firsts {
			parser.table.firsts
		}
	}
}

generate_table :: proc(parser: ^Parser, token_ids: typeid) {
	parser.table = new(ParseTable)
	parser.table.token_names = token_names
	
	// 0. Input var names
	parser.table.var_names = make([dynamic]string)
	for rule in parser.rules {
		append(paser.table.var_names, rule.left)
	}

	// 1. Calcuate all firsts
	calculate_firsts(parser)

	// 2. Calculate all follows
}
