package ast

module :: struct {
	path: string,
	actions: []action,
}

action :: union #no_nil {
	action_import,
	action_expr,
	action_declare,
	action_if_else,
	action_for_else,
	action_match_case_else,
	action_loop_control,
}

action_import :: struct {
	module: string,
	symbols: []string,
}

action_expr :: struct {
	variables: []union #no_nil {action_declare, expr},
	exprs: []expr,
}

action_declare :: struct {
	name: string,
	type: union{expr},
}

action_if_else :: struct {
	if_else: []struct {
		condition: expr,
		then: []action,
	},
	else_: []action,
}

action_match_case_else :: struct {
	matches: []expr,
	cases: []struct {
		exprs: []expr,
		body: []action,
	},
	else_: []action,
}

action_for_else :: struct {
	condition: expr,
	body: []action,
	else_: []action,
}

action_loop_control :: struct {
	kind: enum { CONTINUE = 1, BREAK, },
	depth: int,
}
