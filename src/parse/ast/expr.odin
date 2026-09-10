package ast

expr :: struct {
	comptime: bool,
	value: union #no_nil {
		expr_type,
		expr_ident,
		expr_getfield,
		expr_function,
		expr_block,
		expr_call,
		expr_unop,
		expr_binop,
		expr_index,
		expr_slice,
		expr_int,
		expr_float,
		expr_string,
		expr_array,
		expr_map,
		expr_fields,
	},
}

expr_ident :: string

expr_getfield :: struct {
	expr: ^expr,
	field: string,
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
	code: []action,
}

expr_block :: []action

expr_call :: struct {
	function: ^expr,
	arguments: []expr,
}

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

expr_index :: struct {
	expr_: ^expr,
	index: ^expr,
}

expr_slice :: struct {
	expr_: ^expr,
	from, to, step: union{^expr},
}

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

expr_array :: []expr

expr_map :: []struct {
	key: expr,
	value: expr,
}

expr_fields :: []struct {
	name: union{string},
	value: expr,
}
