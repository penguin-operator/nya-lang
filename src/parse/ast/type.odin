package ast

expr_type :: union #no_nil {
	type_number,
	type_array,
	type_map,
	type_compound,
	type_function,
}

type_number :: enum {
	U8 = 1, I8, U16, I16, U32, I32, U64, I64, F32, F64,
}

type_array :: struct {
	type: ^expr_type,
	pre_alloc: union{uint},
}

type_map :: struct {
	key_type, value_type: ^expr_type,
}

type_compound :: struct {
	type: enum {
		STRUCT = 1,
		UNION,
		ENUM,
	},
	fields: []struct {
		name: union{string},
		type: expr,
		init: expr,
	},
}

type_function :: struct {
	arguments, returns: []struct {
		name: union{string},
		type: expr,
		init: expr,
	},
	noreturn: bool,
}
