#!/bin/bash

# Define a altura do painel do terminal
TERMINAL_HEIGHT=10

# Captura o diretório atual do painel ativo
CURRENT_DIR=$(tmux display-message -p '#{pane_current_path}')

# Verifica se o painel do terminal já existe
terminal_exists=$(tmux list-panes -F '#{pane_title}' | grep -c "terminal_panel")

if [ $terminal_exists -eq 0 ]; then
    # O terminal não existe, então vamos criar
    # Salva o ID do painel atual
    CURRENT_PANE=$(tmux display-message -p '#{pane_id}')
    
    # Cria o painel do terminal na parte inferior
    tmux split-window -v -l $TERMINAL_HEIGHT -c "$CURRENT_DIR"
    
    # Marca este painel com um título especial
    tmux select-pane -T "terminal_panel"
    
    # Volta para o painel original
    #tmux select-pane -t $CURRENT_PANE
else
    # O terminal já existe
    # Verifica se está visível
    visible_panels=$(tmux list-panes | wc -l)
    
    if [ $visible_panels -eq 1 ]; then
        # Terminal não está visível, vamos mostrá-lo
        # Salva o ID do painel atual
        CURRENT_PANE=$(tmux display-message -p '#{pane_id}')
        
        # Encontra e mostra o painel do terminal
        tmux split-window -v -l $TERMINAL_HEIGHT -c "$CURRENT_DIR"
        tmux select-pane -T "terminal_panel"
        
        # Volta para o painel original
        #tmux select-pane -t $CURRENT_PANE
    else
        # Terminal está visível, vamos escondê-lo
        # Salva o ID do painel atual para retornar depois
        CURRENT_PANE=$(tmux display-message -p '#{pane_id}')
        
        # Encontra e mata o painel do terminal
        TERMINAL_PANE=$(tmux list-panes -F '#{pane_id}:#{pane_title}' | grep "terminal_panel" | cut -d':' -f1)
        if [ ! -z "$TERMINAL_PANE" ]; then
            tmux kill-pane -t $TERMINAL_PANE
        fi
        
        # Volta para o painel onde estava antes
        #tmux select-pane -t $CURRENT_PANE
    fi
fi
