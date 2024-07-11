function extract() {
    local file_path=$1
    if [ -f ${file_path} ]; then
        case ${file_path} in
            *.tar.bz2)   tar xvjf ${file_path}     ;;
            *.tar.gz)    tar xvzf ${file_path}     ;;
            *.bz2)       bunzip2 ${file_path}      ;;
            *.rar)       unrar x ${file_path}      ;;
            *.gz)        gunzip ${file_path}       ;;
            *.tar)       tar xvf ${file_path}      ;;
            *.tbz2)      tar xvjf ${file_path}     ;;
            *.tgz)       tar xvzf ${file_path}     ;;
            *.zip)       unzip ${file_path}        ;;
            *.Z)         uncompress ${file_path}   ;;
            *.7z)        7z x ${file_path}         ;;
            *)           echo "${file_path} cannot be extracted via >extract<" ;;
        esac
    else
        echo "${file_path} is not a valid file!"
    fi
}
