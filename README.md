# vim-customcpt

Easily create custom completion menus using any dictionary/json file, in the format:

`{ 'word(' : { 'kind' : 'f', 'menu' : 'menu', 'info' : 'info' } }`

*Or* a tab-separated values file, like this:

`word   kind    menu    info`

So, for instance, a WordPress function (a full example wordpress.json file is included in this repo):

```
{
  'get_bloginfo(' : {
    'kind' : 'f',
    'menu' : 'string $show, string $filter | string',
    'info' : 'Retrieves information about the current site.',
  }
}
```


Or, as tab-separated values:

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

Your custom completion file will show up as a "full" complete menu similar to the omnicomplete menu, like so:

![](https://d1zjcuqflbd5k.cloudfront.net/files/acc_68608/VbAy?response-content-disposition=inline;%20filename=Screen%20Shot%202017-01-06%20at%201.41.23%20PM.png&Expires=1483728413&Signature=BYKH7rajDKlwXI8qJGQOxheguw08i-4YPPmtVE2ZFYbF3~cCTvNA1r0g8kUd~k79l4OTteUnbPPozQ6bchfDowrU-2-1SIPVF5DKsevTdntteyfNvl71eh4ctl8bnMn8aElrDz7rWjzlOEKufvXh2q8ICDvq6nm6EpPuFdduTts_&Key-Pair-Id=APKAJTEIOJM3LSMN33SA)

## Options

By itself, this plugin does nothing. Only by setting a couple dictionaries in your `.vimrc` will `<C-X><C-U>` use the completion function generated by your file.

`g:customcpt_funcs`: A Dictionary with a function name for a key and a List of files to use for completion with it
```

let g:customcpt_funcs = {
		\ 'WPComplete' : [
			\ $HOME . '/.vim/wordpress.json',
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

Though, all this does is `set completefunc` for those filetypes, which could just as easily be done manually.

## Thanks

This plugin is heavily based on @aaronspring&rsquo;s [cdo_lazy_vim](https://github.com/aaronspring/cdo_lazy_vim) plugin. Thanks Aaron! &#x1F44B;

Thanks also to Steve Losh&rsquo;s [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com) and the Stack Exchange community.

---

Related: [CompleteHelper](http://www.vim.org/scripts/script.php?script_id=3914)
