# vim-customcpt

Easily create custom completion menus using any tab-separated file, in the format:

`word   kind    menu    info`

So, for instance, a WordPress function:

`get_bloginfo(	f	string $show, string $filter | string	Retrieves information about the current site.`

See `:help complete-items` for more info:

```
	word		the text that will be inserted, mandatory
	kind		single letter indicating the type of completion
	menu		extra text for the popup menu, displayed after "word"
				or "abbr"
	info		more information about the item, can be displayed in a
				preview window
```

## Options

By itself, this plugin does nothing. Only by setting a couple dictionaries in your `.vimrc` will `<C-X><C-U>` use the completion function generated by your file.

`g:customcpt_funcs`: A Dictionary with a function name for a key and a List of files to use for completion with it
```
let g:customcpt_funcs = {
		\ 'WPComplete' : [
			\ $HOME . '/.vim/dict/wordpress',
		\ ]
	\ }
endif
```
`g:customcpt_types`: A Dictionary with a comma-separated list of filetypes as keys and the name of a completion function to use with them
```
let g:customcpt_types =  {
			\ 'php,php.html' : 'WPComplete',
	\ }
endif
```

## Thanks

This plugin is heavily based on @aaronspring&rsquo;s [cdo_lazy_vim](https://github.com/aaronspring/cdo_lazy_vim) plugin. Thanks Aaron! &#x1F44B;

Thanks also to Steve Losh&rsquo;s [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com) and the Stack Exchange community.

---

Related: [CompleteHelper](http://www.vim.org/scripts/script.php?script_id=3914)
