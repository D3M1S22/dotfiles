{ pkgs, config, dotfiles, ...}: {

  home.packages = with pkgs; [
    # Altri pacchetti esistenti...

    # Eseguibile globale che fa il fetch e lancia lo script remoto
    (pkgs.writeShellScriptBin "pull-rules" ''
      if [ -z "$1" ]; then
        echo "Errore: Specifica lo stack desiderato."
        echo "Uso: pull-rules [react-web|react-native|node-backend]"
        exit 1
      fi
      
      # Usa curl per scaricare lo script RAW da GitHub e passargli l'argomento
      curl -sL curl -sL https://raw.githubusercontent.com/d3m1s22/ai-agent-rules/main/scripts/pull-rules.sh | bash -s -- "$1"
    '')
  ];

  ## loading zsh config
 programs.zsh = {
    enable = true;
    initContent = ''
      source ${dotfiles}/zsh/.zshrc
    '';
  };
}