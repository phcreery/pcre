module pcre

fn test_match_after() {
	r := new_regex('Match everything after this: (.+)', 0) or { panic('An error occured!') }

	m := r.match_str('Match everything after this: "I <3 VLang!"', 0, 0) or { panic('No match!') }

	// m.get(0) -> Match everything after this: "I <3 VLang!"
	// m.get(1) -> "I <3 VLang!"
	// m.get(2) -> Error!
	whole_match := m.get(0) or { panic('We matched nothing...') }

	matched_str := m.get(1) or { panic('We matched nothing...') }

	assert whole_match == 'Match everything after this: "I <3 VLang!"'
	assert matched_str == '"I <3 VLang!"'

	r.free()
}

fn test_match_str_iterator() {
	mut re := new_regex(r'(.)', 0)! // match each of the letters
	matches := re.match_str('abcdef', 0, 0)!
	mut out := []string{}
	for m in matches {
		out << m.get(0)!
		assert m.get_all().len == 1
	}
	assert out == ['a', 'b', 'c', 'd', 'e', 'f']
}

fn test_match_str_many() {
	mut re := new_regex(r'(^it.*)(a\w*)', 0)! // match each of the letters
	str := '
>miss
it
iter
intern
item
>hit
iterate
italic
iterable
	'
	// I dont think match_str_many is needed since match_str with get all can be used
	all_matches := re.match_str(str, 0, 0) or { panic('No match!') }
	dump(all_matches)

	lines := str.split('\n')
	println(lines)
	mut out := []string{}
	for i in 0 .. lines.len {
		line := lines[i]
		matches := re.match_str(line, 0, 0) or { continue }
		for m in matches {
			assert m.get_all().len == 2
			out << m.get(0)!
			out << m.get(1)!
			out << m.get(2)!
		}
	}
	assert out == ['iterate', 'iter', 'ate', 'italic', 'it', 'alic', 'iterable', 'iter', 'able']
}
