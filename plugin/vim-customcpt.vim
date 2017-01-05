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
			let s:cdo_data = []
			for cptfile in s:cptfiles
				let s:cdo_data = extend(s:cdo_data, readfile(cptfile))
			endfor
			for l:line in s:cdo_data
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
