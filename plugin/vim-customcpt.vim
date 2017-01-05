if !exists('g:customcpt_funcs')
	let g:customcpt_funcs = {}
endif

if !exists('g:customcpt_types')
	let g:customcpt_types =  {}
endif

for [s:cptfunc, s:cptfiles] in items(g:customcpt_funcs)

	fun! {s:cptfunc}(findstart, base)
		if a:findstart
			let l:line = getline('.')
			let l:start = col('.') - 1
			while l:start > 0 && l:line[l:start - 1] =~ '\k'
				let l:start -= 1
			endwhile
			return start
		else

			" Record what matches − we pass this to complete() later
			let l:res = []

			" Find cdo matches
			let s:lst = [] " List for tsv files
			let s:dctnry = {} " Dict for dictionary/json files

			for cptfile in s:cptfiles
				try
					let file = eval(join(readfile(cptfile)))
					let s:dctnry = extend(s:dctnry, file) " do this if we want to use a dictionary instead
				catch
					let file = readfile(cptfile)
					let s:lst = extend(s:lst, file)
				endtry
			endfor

			" Parse dictionary/json files
			let s:i = 1
			for [s:dkey, s:dobj] in sort(items(s:dctnry))
				if s:i > 20
					break
				endif
				if s:dkey =~ '^' . a:base
					let s:word = s:dkey
					if has_key(s:dobj, 'kind')
						let s:kind = s:dobj['kind']
					else
						let s:kind = ''
					endif
					if has_key(s:dobj, 'menu')
						let s:menu = s:dobj['menu']
					else
						let s:menu = ''
					endif
					call add(l:res, {
								\ 'word': a:base
								\ })
					call add(l:res, {
								\ 'word' : s:word,
								\ 'kind' : s:kind,
								\ 'menu' : s:menu
								\ })
					let s:i = s:i + 1
				endif
			endfor

			" Parse tsv files
			let s:i = 1
			for l:line in s:lst
				if s:i > 20
					break
				endif
				" Check if it matches what we're trying to complete
				let s:split = split(l:line, '	')
				if s:split[0] =~ '^' . a:base
					" It matches! See :help complete() for the full docs on the key names
					" for this dict.
					let s:word = s:split[0]
					let s:abbr = s:split[0]
					if len(s:split) > 1
						let s:kind = s:split[1]
					else
						let s:kind = ''
					endif
					if len(s:split) > 2
						let s:menu = s:split[2]
					else
						let s:menu = ''
					endif
					if len(s:split) > 3
						let s:info = s:split[3]
					else
						let s:info = ' '
					endif
					call add(l:res, {
								\ 'word': a:base
								\ })
					call add(l:res, {
								\ 'icase': 1,
								\ 'word': s:word,
								\ 'abbr': s:abbr,
								\ 'kind': s:kind,
								\ 'menu': s:menu,
								\ 'info': s:info,
								\ })
					let s:i = s:i + 1
				endif
			endfor
			return res
		endif
	endfun

endfor

for [s:cpttype, s:cptfunc] in items(g:customcpt_types)
	if !exists(s:cptfunc)
		execute 'au FileType ' . s:cpttype . ' setlocal completefunc=' . s:cptfunc
	endif
endfor
