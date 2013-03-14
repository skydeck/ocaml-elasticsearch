(* Auto-generated from "es_field_types.atd" *)


type utf8 = string

type base64 = string

type text = utf8

type token = utf8

type binary = base64

type integer = int

type byte = int

type boolean = bool

type null = unit

type coord = { lat: float; lon: float }

type date = string

type 'a array = 'a list
