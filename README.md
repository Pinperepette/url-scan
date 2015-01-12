# url-scan
un semplice script per scrivere in un file tutti gli url di un sito
OPTIONS:

   -h      Show this message
   -t      Target
   -s      Time Sleep #(il tempo del comando sleep, che serve a non farsi bannare da google)
   -p      Set Scan # 3 livelli di ricerca
           1 (default scan)
           2 (Ghost scan)
           3 (Uber scan)
Funziona sia su linux che su mac osx, a patto che su mac abbiate 2 versioni di grep
per installarle :

dovete avere brew [ per installarlo ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"]

sudo brew tap homebrew/dupes

brew install homebrew/dupes/grep

brew install pcre

ln -s /usr/local/Cellar/grep/2.14/bin/ggrep /usr/bin/ggrep
