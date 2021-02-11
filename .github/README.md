# Markdown Surrounds
[heading__top]:
  #markdown-surrounds
  "&#x2B06; Toggles MarkDown elements; bold, italic, and strike-through"


Toggles MarkDown elements; bold, italic, and strike-through


## [![Byte size of Markdown Surrounds][badge__main__markdown_surrounds__source_code]][markdown_surrounds__main__source_code] [![Open Issues][badge__issues__markdown_surrounds]][issues__markdown_surrounds] [![Open Pull Requests][badge__pull_requests__markdown_surrounds]][pull_requests__markdown_surrounds] [![Latest commits][badge__commits__markdown_surrounds__main]][commits__markdown_surrounds__main]


---


- [:arrow_up: Top of Document][heading__top]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start][heading__quick_start]

  - [:floppy_disk: Clone][heading__clone]
  - [:heavy_plus_sign: Install][heading__install]
  - [:fire: Uninstall][heading__uninstall]
  - [:arrow_up: Upgrade][heading__upgrade]
  - [:bookmark_tabs: Documentation][heading__documentation]

- [&#x1F9F0; Usage][heading__usage]

- [&#x1F5D2; Notes][heading__notes]

- [:chart_with_upwards_trend: Contributing][heading__contributing]

  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


This repository requires the [Vim][link__vim_home] text editor to be installed the source code is available on [GitHub -- `vim/vim`][link__vim_github], and most GNU Linux package managers are able to install Vim directly, eg...


- Arch based Operating Systems


```Bash
sudo packman -Syy

sudo packman -S gawk make vim
```


- Debian derived Distributions


```Bash
sudo apt-get update

sudo apt-get install gawk make vim
```


> Note `gawk` and `make` are only required if **not** utilizing a Vim plugin manager.


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


> Perhaps as easy as one, 2.0,...


---


### Clone
[heading__clone]:
  #clone
  "&#x1f4be;"


Clone this project...


```Bash
mkdir -vp ~/git/hub/vim-utilities

cd ~/git/hub/vim-utilities

git clone git@github.com:vim-utilities/markdown-surrounds.git
```


---


### Install
[heading__install]:
  #install
  "&#x2795;"


If **not** using a plugin manager, then this plugin may be installed via `make install` command...


```Bash
cd ~/git/hub/vim-utilities/markdown-surrounds

make install
```


---


### Uninstall
[heading__uninstall]:
  #uninstall
  "&#x1f525;"


If not using a plugin manager, then this plugin may be uninstalled via `uninstall` Make target...


```Bash
cd ~/git/hub/vim-utilities/markdown-surrounds

make uninstall
```


... Which will remove symbolic links and update the Vim help tags file.


---


### Upgrade
[heading__upgrade]:
  #upgrade
  "&#x2b06;"


To update in the future use `make upgrade` command...


```Bash
cd ~/git/hub/vim-utilities/markdown-surrounds

make upgrade
```


---


### Documentation
[heading__documentation]:
  #documentation
  "&#x1F4D1;"


After installation, plugin documentation may be accessed via Vim's `:help` command, eg...


```Vim
:help markdown-surrounds.txt
```


______


### Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


Normal mode default maps are provided for toggling bold, italic, and strike-through state; either for the current word, or line, that the cursor is on.


- `<Leader>`<kbd>b</kbd> toggle bold state of word under cursor.

- `<Leader>`<kbd>B</kbd> toggle bold state of line under cursor.

- `<Leader>`<kbd>i</kbd> toggle italic state of word under cursor.

- `<Leader>`<kbd>I</kbd> toggle italic state of line under cursor.

- `<Leader>`<kbd>hi</kbd> toggle highlight state of current word.

- `<Leader>`<kbd>HI</kbd> toggle highlight state current line.

- `<Leader>`<kbd>st</kbd> toggle strike-through state of current word.

- `<Leader>`<kbd>ST</kbd> toggle strike-through state current line.


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


This repository may not be feature complete and/or fully functional, Pull Requests that add features or fix bugs are certainly welcomed.


---


Currently when toggling state of words `<cWORD>` is used for obtaining the _big-word_ that the cursor is on. This means punctuation and non-letter symbols are included when toggling state. For example toggling bold state of an existing italic word...


**Example italic word toggling results**


```MarkDown
Spam _flavored_ ham
```


**Example bolding italic word toggling results**


```MarkDown
Spam **_flavored_** ham
```


... this also means that currently to toggle italic state again requires first toggling bold state, ie. order of operations is outer-to-inner, eg...


**Example out-of-order italic toggling results**


```MarkDown
Spam _**_flavored_**_ ham
```


... to obtain an un-formatted word from above example would then require the following sequence of commands...


- `<Leader>`<kbd>i</kbd>


```MarkDown
Spam **_flavored_** ham
```


- `<Leader>`<kbd>b</kbd>


```MarkDown
Spam _flavored_ ham
```

- `<Leader>`<kbd>i</kbd>


```MarkDown
Spam flavored ham
```


---


When toggling current line state block-quote, un-ordered lists, and ordered lists are ignored, eg...


**Example block-quoted line**


```MarkDown
> Block quoted line
```


**Example strike-through block-quote**


```MarkDown
> ~~Block quoted line~~
```


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to markdown-surrounds and vim-utilities"


Options for contributing to markdown-surrounds and vim-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking markdown-surrounds"


Start making a [Fork][markdown_surrounds__fork_it] of this repository to an account that you have write permissions for.


- Add remote for fork URL. The URL syntax is _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/vim-utilities/markdown-surrounds

git remote add fork git@github.com:<NAME>/markdown-surrounds.git
```


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/vim-utilities/markdown-surrounds


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


> Note, the `-u` option may be used to set `fork` as the default remote, eg. _`git push -u fork main`_ however, this will also default the `fork` remote for pulling from too! Meaning that pulling updates from `origin` must be done explicitly, eg. _`git pull origin main`_


- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications before being accepted, please check the [dot-github](https://github.com/vim-utilities/.github) repository for detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting vim-utilities that maintains markdown-surrounds"


Thanks for even considering it!


Via Liberapay you may <sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a repeating basis.


Regardless of if you're able to financially support projects such as markdown-surrounds that vim-utilities maintains, please consider sharing projects that are useful with others, because one of the goals of maintaining Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- `:help :map-<buffer>`

- `:help curly-braces-function-names`

- `:help fnamemodify()`

- `:help readfile()`

- `:help json_decode()`

- `:help type()`

- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)

- [StackExchange -- Vi -- How can I merge two dictionaries in Vim?](https://vi.stackexchange.com/questions/20842/)

- [StackOverflow -- How do I disable the "Press ENTER or type command to continue" prompt in Vim?](https://stackoverflow.com/questions/890802/)

- [StackOverflow -- Passing a dictionary to a function in viml](https://stackoverflow.com/questions/41433881/)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
Toggles MarkDown elements; bold, italic, and strike-through
Copyright (C) 2020 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"


[badge__commits__markdown_surrounds__main]:
  https://img.shields.io/github/last-commit/vim-utilities/markdown-surrounds/main.svg

[commits__markdown_surrounds__main]:
  https://github.com/vim-utilities/markdown-surrounds/commits/main
  "&#x1F4DD; History of changes on this branch"


[markdown_surrounds__community]:
  https://github.com/vim-utilities/markdown-surrounds/community
  "&#x1F331; Dedicated to functioning code"


[issues__markdown_surrounds]:
  https://github.com/vim-utilities/markdown-surrounds/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[markdown_surrounds__fork_it]:
  https://github.com/vim-utilities/markdown-surrounds/
  "&#x1F531; Fork it!"

[pull_requests__markdown_surrounds]:
  https://github.com/vim-utilities/markdown-surrounds/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[markdown_surrounds__main__source_code]:
  https://github.com/vim-utilities/markdown-surrounds/
  "&#x2328; Project source!"

[badge__issues__markdown_surrounds]:
  https://img.shields.io/github/issues/vim-utilities/markdown-surrounds.svg

[badge__pull_requests__markdown_surrounds]:
  https://img.shields.io/github/issues-pr/vim-utilities/markdown-surrounds.svg

[badge__main__markdown_surrounds__source_code]:
  https://img.shields.io/github/repo-size/vim-utilities/markdown-surrounds


[link__vim_home]:
  https://www.vim.org
  "Home page for the Vim text editor"

[link__vim_github]:
  https://github.com/vim/vim
  "Source code for Vim on GitHub"


[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=vim-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/vim-utilities
  "&#x1F4B1; Sponsor developments and projects that vim-utilities maintains via Liberapay"

