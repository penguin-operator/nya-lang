package ast

expr :: struct {
	comptime: bool,
	value: union #no_nil {
		expr_ident,
		expr_int,
		expr_float,
		expr_string,
		expr_unop,
		expr_binop,
		expr_array,
		expr_map,
		expr_fields,
		expr_index,
		expr_getfield,
		expr_slice,
		expr_call,
		expr_function,
		expr_type,
		expr_declare,
		expr_assign,
		expr_if_else,
		expr_match_else,
		expr_for_else,
		expr_loop_control,
		expr_import,
	},
}

expr_ident :: string

expr_int :: struct {
	value: int,
	repr: enum {
		DECIMAL = 1,
		HEXADECIMAL,
		BINARY,
		OCTAL,
	},
}

expr_float :: struct {
	integer: int,
	exponent: int,
}

expr_string :: []rune

expr_unop :: struct {
	op: enum {
		PREINC = 1,
		POSTINC,
		PREDEC,
		POSTDEC,
		BITNOT,
		BOOLNOT,
		NEG,
		REF,
		DEREF,
	},
	expr: ^expr,
}

expr_binop :: struct {
	op: enum {
		ADD = 1,
		SUB,
		MUL,
		DIV,
		MOD,
		BOOLAND,
		BOOLOR,
		BOOLXOR,
		BITAND,
		BITOR,
		BITXOR,
		EQ,
		NEQ,
		LT,
		GT,
		LEQ,
		GEQ,
		LSHIFT,
		RSHIFT,
	},
	lhs, rhs: ^expr,
}

expr_array :: []expr

expr_map :: []struct {
	key: expr,
	value: expr,
}

expr_fields :: []struct {
	name: union{string},
	value: expr,
}

expr_index :: struct {
	expr_: ^expr,
	index: ^expr,
}

expr_getfield :: struct {
	expr: ^expr,
	field: string,
}

expr_slice :: struct {
	expr_: ^expr,
	from, to, step: union{^expr},
}

expr_call :: struct {
	function: ^expr,
	arguments: []expr,
}

expr_function :: struct {
	arguments: []struct {
		name: string,
		type: expr,
		init: union{expr},
	},
	returns: []struct {
		name: union{string},
		type: expr,
		init: union{expr},
	},
	noreturn: bool,
	code: []expr,
}

expr_declare :: struct {
	name: string,
	type: union{^expr},
}

expr_assign :: struct {
	variables: []expr,
	exprs: []expr,
}

expr_if_else :: struct {
	condition: ^expr,
	then: []expr,
	else_: []expr,
}

expr_match_else :: struct {
	expr_: ^expr,
	branches: []struct {
		pattern: ^expr,
		code: []expr,
	},
	else_: []expr,
}

expr_for_else :: struct {
	condition_: ^expr,
	body: []expr,
	else_: []expr,
}

expr_loop_control :: struct {
	kind: enum { CONTINUE = 1, BREAK, },
	depth: int,
}

expr_import :: struct {
	module: string,
	symbols: []string,
}
