#!/bin/bash
# -*- ENCODING: UTF-8 -*-

clear
ROJO='\033[1;31m'
CIAN='\033[1;36m'
BLUE='\033[1;34m'
NC='\033[0m'
printf "${CIAN}[JARVIS SAY] >${NC} #######################################################\n";
printf "${CIAN}[JARVIS SAY] >${NC} -------------------------- ${BLUE}JARVIS ${NC}---------------------\n";
printf "${CIAN}[JARVIS SAY] >${NC} #######################################################\n";
echo
echo
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Estoy eliminando carpetas /temp y /origin.git, espere por favor \n"
rm -rf temp/ && rm -rf origin.git/
printf "${CIAN}[JARVIS SAY] >${NC} Carpetas temporeles eliminadas \n"
echo
printf "${CIAN}[JARVIS SAY] > ${NC} Digite la url del proyecto del svn  ${ROJO}>>>  "
read  svnUrl
printf "${CIAN}[JARVIS SAY] >${NC} Clonando el repositorio${BLUE} $svnUrl ${NC} \n"
echo
#--stdlayout
git svn clone $svnUrl --no-metadata -A users.properties --stdlayout ./temp 
#git svn clone http://soft.fcv.org:90/svn/S2 --no-metadata -A users.properties -t tags -b branches ./temp
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} Vamos a crear el repositorio limpio \n"
read salir
cd temp
printf "${CIAN}[JARVIS SAY] >${NC} Vamos a cambiar la codificación del repositorio \n"
java -Dfile.encoding=utf-8 -jar ../svn-migration-scripts.jar clean-git --force
git init --bare ../origin.git
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} Referenciando los heads del repositorio \n"
read salir
cd ../origin.git &&  git symbolic-ref HEAD refs/heads/trunk
echo
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} se agrega el repositorio limpio como origen remoto \n"
read salir
cd ../temp && git remote add bare ../origin.git
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} se hace la referencia al repositorio remoto temporal \n"
read salir
git config remote.bare.push 'refs/remotes/*:refs/heads/*'
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} Enviamos todo al repositorio remoto origin.git \n"
read salir
git push --set-upstream bare
printf "${CIAN}[JARVIS SAY] >${NC} OK \n"
echo
printf "${CIAN}[JARVIS SAY] >${NC} Contenido del reposiorio remoto \n"
read salir
cd ../origin.git && git branch -l
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Se leen las ramas \n"
IFS=$'\n'; read ramas <<<$(git branch -l ); unset IFS;
echo
echo
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Estas son las ramas actuales \n"
git branch -l
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Vamos a crear los tags \n"
# se recorren las ramas para crear los tags
for rama in $ramas
do
        if [[ $rama == "origin/tags/"* ]]
        then

            IFS='//'; var=($rama) ;
            printf "${CIAN}[JARVIS SAY] >${NC} ${ROJO} Tag: v${var[2]} ${NC}==>  ${BLUE} $rama ${NC}\n"
            read
            git tag "${var[2]}" "$rama";
            printf "${CIAN}[JARVIS SAY] >${NC} Se creo el nuevo tag ${BLUE} ${var[2]} ${NC} \n";
            git branch -D "$rama";
            printf "${CIAN}[JARVIS SAY] >${NC} Se borra la rama ${ROJO}  $rama ${NC} \n";
            echo
            echo
        fi
done

printf "${CIAN}[JARVIS SAY] >${NC}   tags  actuales\n"
git tag  -l
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC}  ramas actuales \n"
git branch  -l
echo
echo

git config http.sslVerify false

#cd ../origin.git

echo
echo
IFS=$'\n'; read ramas <<<$(git branch -l ); unset IFS;
# se recorren las ramas para renombrar las ramas
for rama in $ramas
do
        printf "${CIAN}[JARVIS SAY] >${NC} Decida que hacer con las siguiente rama >> ${BLUE} $rama ${NC}\n"
        printf "${CIAN}[JARVIS SAY] >${NC} --------${CIAN} MENU ${NC}--------\n"
        printf "${CIAN}[JARVIS SAY] >${NC} ${ROJO}X ${NC}==> ${ROJO}Eliminar rama  \n"
        printf "${CIAN}[JARVIS SAY] >${NC} ${BLUE}N ${NC}==> ${BLUE}Crear nueva rama  \n"
        printf "${CIAN}[JARVIS SAY] >${NC} C ==> Ignorar y continuar  \n"

        printf "${CIAN}[JARVIS SAY] >${NC} Digite la opcion (${ROJO}X ${NC}/${BLUE}N ${NC}/${ROJO}C ${NC}) ${ROJO}>>>    "
        read  opcion
            case $opcion in
            x|X)
                echo
                echo
                git branch -D "$rama"
                printf "${CIAN}[JARVIS SAY] >${NC} se elimino la rama ${ROJO}  $rama ${NC}  \n"
                echo
                echo
            ;;
            n|N)
                echo
                echo
                printf "${CIAN}[JARVIS SAY] >${NC} Se va a crear la nueva rama para ${BLUE} $rama ${NC} \n"
                echo
                printf "${CIAN}[JARVIS SAY] >${NC} Digite el nuevo nombre para la rama ${ROJO}>>>  "
                read newBranchName;
                echo
                echo
                git branch -m "$rama"  "$newBranchName";
                printf "${CIAN}[JARVIS SAY] >${NC} se creo la rama ${BLUE} $newBranchName ${NC} con ${BLUE} $rama ${NC} \n"
                echo
                echo
            ;;
            c|C)
                printf "${CIAN}[JARVIS SAY] >${NC} rama ignorada ${ROJO} $rama ${NC} \n";
                echo
                echo
                ;;
        esac


done
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Removiendo origen remoto \n ";
echo
printf "${CIAN}[JARVIS SAY] >${NC} Digite la nueva ruta de origen remoto (Url de gitLab).git  ${ROJO}>>>   " 
read  urlPath
git remote add origin $urlPath;
printf "${CIAN}[JARVIS SAY] >${NC} Contenido del repositorio  \n";
printf "${CIAN}[JARVIS SAY] >${NC}   tags  \n"
git tag  -l
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC}  ramas \n"
git branch  -l
echo
echo
printf "${CIAN}[JARVIS SAY] >${NC} Todo el contenido anterior sera enviado al origen remoto ${BLUE} $urlPath ${NC} \n ${BLUE} ";
read
git push --all && git push --tags
echo
printf "${CIAN}[JARVIS SAY] >${NC}  ${BLUE} Se ha enviado todo el contenido  satisfactoriamente ${NC} \n";
echo
printf "${CIAN}[JARVIS SAY] >${NC} #######################################################\n";
printf "${CIAN}[JARVIS SAY] >${NC} ---------------------------${BLUE} BYE ${NC}-----------------------\n";
printf "${CIAN}[JARVIS SAY] >${NC} #######################################################\n";
echo
echo
exit 0

# read opcion
#     case $opcion in
#       b|B)
#          limpiarPantalla
#       ;;
#       l|L)
#          listarETC
#       ;;
#       c|C)
#          crearDirectorio ;;
#   esac