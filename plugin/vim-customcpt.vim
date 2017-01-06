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
			let l:lst = [] " List for tsv files
			let l:dctnry = {} " Dict for dictionary/json files

			for cptfile in s:cptfiles
				try
					let file = eval(join(readfile(cptfile)))
					let l:dctnry = extend(l:dctnry, file) " do this if we want to use a dictionary instead
				catch
					let file = readfile(cptfile)
					let l:lst = extend(l:lst, file)
				endtry
			endfor

			" Parse dictionary/json files
			let l:i = 1
			for [l:dkey, l:dobj] in sort(items(l:dctnry))
				if l:i > 20
					break
				endif
				if l:dkey =~ '^' . a:base
					let l:word = l:dkey
					if has_key(l:dobj, 'kind')
						let l:kind = l:dobj['kind']
					else
						let l:kind = ''
					endif
					if has_key(l:dobj, 'menu')
						let l:menu = l:dobj['menu']
					else
						let l:menu = ''
					endif
					if has_key(l:dobj, 'info')
						let l:info = l:dobj['info']
					else
						let l:info = ' '
					endif
					call add(l:res, {
								\ 'word': a:base
								\ })
					call add(l:res, {
								\ 'word' : l:word,
								\ 'kind' : l:kind,
								\ 'menu' : l:menu,
								\ 'info' : l:info,
								\ })
					let l:i = l:i + 1
				endif
			endfor

			" Parse tsv files
			let l:i = 1
			for l:line in l:lst
				if l:i > 20
					break
				endif
				" Check if it matches what we're trying to complete
				let l:split = split(l:line, '	')
				if l:split[0] =~ '^' . a:base
					" It matches! See :help complete() for the full docs on the key names
					" for this dict.
					let l:word = l:split[0]
					let l:abbr = l:split[0]
					if len(l:split) > 1
						let l:kind = l:split[1]
					else
						let l:kind = ''
					endif
					if len(l:split) > 2
						let l:menu = l:split[2]
					else
						let l:menu = ''
					endif
					if len(l:split) > 3
						let l:info = l:split[3]
					else
						let l:info = ' '
					endif
					call add(l:res, {
								\ 'word': a:base
								\ })
					call add(l:res, {
								\ 'icase': 1,
								\ 'word': l:word,
								\ 'abbr': l:abbr,
								\ 'kind': l:kind,
								\ 'menu': l:menu,
								\ 'info': l:info,
								\ })
					let l:i = l:i + 1
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
