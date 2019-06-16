#!/bin/bash
# Create a user to SSH into as.
useradd yoohey
echo 'yoohey:yoohey' | chpasswd
 
#   motif \
#   zlib-devel.x86_64 \
#   libpng12-devel \
#   java-1.8.0-openjdk-devel.x86_64 \
#   xorg-x11-server-Xvfb \
#   unixODBC-devel.x86_64 \
#   unixODBC.x86_64 \

export ZDOTDIR=/home/yoohey/.zsh
mkdir -p ${ZDOTDIR}

cat << 'eof' > /home/yoohey/.zshenv
export ZDOTDIR=${HOME}/.zsh
source ${ZDOTDIR}/.zshenv
eof

cat << 'eof' > ${ZDOTDIR}/zshenv
export LANG=C
export PATH=.:$PATH
eof
ln -s ${ZDOTDIR}/zshenv ${ZDOTDIR}/.zshenv

cat << 'eof' > ${ZDOTDIR}/zlogin
cowsay -f ghostbusters `fortune`
eof
ln -s ${ZDOTDIR}/zlogin ${ZDOTDIR}/.zlogin

#setting zshrc
cat << 'eof' > ${ZDOTDIR}/zshrc
#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
 
autoload -U compinit
compinit
 
#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
 
zstyle ':completion:*:processes' menu yes select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=1
 
setopt auto_pushd
setopt pushd_ignore_dups
setopt list_packed
setopt NO_HUP
setopt extended_history
setopt append_history
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt no_beep
setopt magic_equal_subst
setopt mark_dirs
setopt print_eight_bit
setopt complete_in_word
setopt ignore_eof
setopt long_list_jobs
setopt transient_rprompt

setopt hist_expand
setopt extended_glob
 
alias ls='ls -F --color=always'
alias ll='ls -laF --color=always'
alias ltr='ls -ltrF --color=always --time-style=+"%Y/%m/%d %H:%M:%S"'
alias la='ls -aF --color=always'
alias l='ls -lF --color=always'
alias l.='\ls -d --color=always .*'
alias ll.='\ls -dl --color=always .*'
alias w3m='w3m -B'
alias du='du -sh'
alias rr="command rm -rf"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias zshrc="vim ~/.zshrc"
alias tmux="LANG=C tmux -u"
alias yum="sudo yum"
alias history="history -df"
 
PROMPT="%m:%n%\\$ "
PROMPT="%n% @%m %# "
#RPROMPT="%r%/% "
#SPROMPT="%r is correct? [n,y,a,e]: "
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} "
 
REPORTTIME=3
 
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'
WORDCHARS=${WORDCHARS:s,/,,}
 
HISTFILE=~/.zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt inc_append_history
setopt no_flow_control
setopt auto_list
 
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete
eof

ln -s ${ZDOTDIR}/zshrc ${ZDOTDIR}/.zshrc

#setting tmux
cat << 'eof' > /home/yoohey/.tmux.conf
set-option -g prefix C-t
#set-option -g status-utf8 on
 
# status
set -g status-fg cyan
set -g status-bg black
set -g status-left-length 30
set -g status-left '#[fg=white,bg=black]#H#[fg=white]:#[fg=white][#S#[fg=white]][#[default]'
set -g status-right '#[fg=black,bg=cyan,bold] [%Y-%m-%d(%a) %H:%M]#[default]'
 
# キーストロークのディレイを減らす
set -sg escape-time 1
# window-status-current
setw -g window-status-current-fg black
setw -g window-status-current-bg cyan
setw -g window-status-current-attr bold#,underscore
# pane-active-border
set -g pane-active-border-fg black
set -g pane-active-border-bg cyan
 
# prefix + C-r で設定ファイルを再読み込み
unbind r
bind C-r source-file ~/.tmux.conf
 
set-option -g default-shell /bin/zsh
#set-option -g mouse-select-pane on
#set-option -g mouse on
#bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
 
set-window-option -g mode-key vi
#set-window-option -g mode-mouse on
 
#set-option -g default-terminal xterm
#set -g default-terminal "screen-256color"
#prerix change C-b -L C-t
set-option -g prefix C-t
bind-key C-t send-prefix
unbind-key C-b
 
# shell
set-option -g default-shell /bin/zsh
set-option -g default-command /bin/zsh
 
# ウィンドウのインデックスを1から始める
set -g base-index 1
 
# C-t*2でtmux内のプログラムにC-tを送る
bind C-t send-prefix
 
# | でペインを縦に分割する
bind | split-window -h
 
# - でペインを横に分割する
bind - split-window -v
 
## Vimのキーバインドでペインを移動する
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+
 
# Vimのキーバインドでペインをリサイズする
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
 
# マウス操作を有効にする
#setw -g mode-mouse on
#set -g mouse-select-pane on
#set -g mouse-resize-pane on
#set -g mouse-select-window on
 
## 256色端末を使用する
#set -g default-terminal "screen-256color"
 
# ステータスバーの色を設定する
set -g status-fg white
set -g status-bg black
#
# ウィンドウリストの色を設定する
setw -g window-status-fg cyan
setw -g window-status-bg default
setw -g window-status-attr dim
# アクティブなウィンドウを目立たせる
setw -g window-status-current-fg white
setw -g window-status-current-bg red
setw -g window-status-current-attr bright
 
# ペインボーダーの色を設定する
set -g pane-border-fg green
set -g pane-border-bg black
# アクティブなペインを目立たせる
#set -g pane-active-border-fg white
#set -g pane-active-border-bg yellow
 
# コマンドラインの色を設定する
set -g message-fg white
set -g message-bg black
set -g message-attr bright
 
# ステータスバーを設定する
## 左パネルを設定する
set -g status-left-length 40
set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
## 右パネルを設定する
set -g status-right "#[fg=cyan][%Y-%m-%d(%a) %H:%M]"
## ステータスド効にする
#set -g status-utf8 on
## リフレッシュの間隔を設定する(デフォルト 15秒)
set -g status-interval 60
## ウィンドウリストの位置を中心寄せにする
#set -g status-justify centre
## ヴィジュアルノーティフィケーションを有効にする
setw -g monitor-activity on
set -g visual-activity on
## ステータスバーを上部に表示する
set -g status-position top
 
# コピーモードを設定する
## viのキーをvi風に設定する
#bind-key -t vi-copy v begin-selection
#bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"
#unbind -t vi-copy Enter
#bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"
eof
 
cat << 'eof' >> /etc/sudoers
yoohey  ALL=(ALL)       NOPASSWD: ALL
eof
 
mkdir -p /home/yoohey/.vim
mkdir -p /home/yoohey/.vim/bak
mkdir -p /home/yoohey/.vim/swp
 
#setting vimrc
cat << 'eof' >> /home/yoohey/.vimrc
syntax on
 
set cpo&vim
set nocp
 
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
 
set autoindent
set backspace=2
set cmdheight=1
set cpoptions+=$
set cursorline
set expandtab
set hidden
set history=500
set hlsearch
set ignorecase
set iminsert=0
set imsearch=-1
set incsearch
set laststatus=2
set noincsearch
set novb
set number
set shiftwidth=3
set shortmess+=I
set showcmd
set showmatch
set showmode
set smartcase
set smartindent
set title
set ts=3
set virtualedit+=block
set wildmenu
set swapfile
set backup
set backupdir=~/.vim/bak " where to put backup file
set directory=~/.vim/swp " where to put swap file
set ambiwidth=double
 
let &statusline='%F%m%r%h%w [#%n][LEN=%L] [FORMAT=%{&ff}] [TYPE=%Y] %=  [%p%%]  %04l,%04v'
 
noremap j gj
noremap k gk
noremap gj j
noremap gk k
 
noremap <C-n> gt
noremap <C-p> gT
noremap tn :<C-u>tabnew
 
noremap Y y$
nnoremap ; :
nnoremap q; q:
 
nnoremap <silent> <Space>.  :<C-u>tabnew $MYVIMRC<CR>
nnoremap <silent> <Space>s. :<C-u>source $MYVIMRC<CR>
 
nnoremap <Space>n :setlocal number! number?^M
nnoremap <Space>h :setlocal hlsearch! hlsearch?^M
 
vnoremap z/ <ESC>/\%V
vnoremap z? <ESC>?\%V
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
vnoremap ; q:i
 
set vb t_vb=
set novb
eof
 
chsh  yoohey -s /bin/zsh
chown yoohey:yoohey -R /home/yoohey
