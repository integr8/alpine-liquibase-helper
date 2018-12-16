: ${SOURCE_METHOD? "Por favor, informe se será GIT ou VOLUME"}

if [ "$SOURCE_METHOD" == 'GIT' ]; then
    : ${GIT_URL?   "Por favor, informe o endereço do repositório do git" }
    : ${GIT_USER?  "Por favor, informe o usuário do git" }
    : ${GIT_EMAIL? "Por favor, informe o email do usuário git" }
    : ${GIT_PASS?  "Por favor, informe a senha do usuario do git" }

    git config --global credential.username ${GIT_USER}
    git config --global credential.helper '!f() { echo "password='${GIT_PASS}'"; }; f'
    git config --global http.sslVerify "false"

    rm $SOURCE_PATH -rf
    git clone --progress --verbose ${GIT_URL} $SOURCE_PATH

elif [ "$SOURCE_METHOD" == 'VOLUME' ]; then

    if [ ! -d "$SOURCE_PATH" ]; then
        echo 'Foi informado que o código fonte seria provido por um volume, mas o diretório não existe'
    fi
fi