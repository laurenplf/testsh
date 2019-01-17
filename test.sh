#!/bin/bash

apt-get update
apt-get install -y libmagic-dev file

truthArray=(
    "find"
    "find ."
    "find ./dossier_test1"
    "find ./dossier_test1/dossier_test2"
    "find /builds/Pierre-Louis.Laurent/rs2018-gadeyne-laurent"
    
    "find -name NULL"
    "find -name fichier_test_1_1.txt"
    "find ./dossier_test1 -name fichier_test_1_1.txt"
    "find ./dossier_test3 -name NULL"
    "find ./dossier_test3 -name fichier_test_1_1.txt"
    
    #"find -print"
    #"find ./dossier_test3 -print"
    
    "grep -r -l . -e NULL"
    "grep -r -l . -e dirent.h"
    "grep -r -l . -e 1_"
    "grep -r -l ./dossier_test3 -e NULL"
    "grep -r -l ./dossier_test3 -e 1"
    
    "find -type f -exec file {} \; | grep image | cut -d : -f 1"
    "find ./dossier_test3 -type f -exec file {} \; | grep image | cut -d : -f 1"
    
    #"find ./.git -exec ls -l -d {} \;"
    #"find ./dossier_test3 -exec ls -l -d {} \;"
    #"find /usr/bin -exec ls -l -d {} \;"
    
    #"find DOSSIER -exec COMMANDE \;"
    "find ./dossier_test3 -exec head {} \;"
    
    "find ./dossier_test3 -type f -exec file {} \; | grep image | cut -d : -f 1"
    "find -name azertyuiop -type f -exec file {} \; | grep image | cut -d : -f 1"
    "find -name 2h6nlob8uzq11 -type f -exec file {} \; | grep image | cut -d : -f 1"
    "find -name 2h6nlob8uzq11.jpg -type f -exec file {} \; | grep image | cut -d : -f 1"
    
    "find ./dossier_test3 -print -exec head {} \;"
    #"find . -print -exec head {} \;"
    
    #"find DOSSIER -name REGEXP"
    #"find DOSSIER -name REGEXP"
    
    #"grep -r -l DOSSIER -e REGEXP"
    #"grep -r -l DOSSIER -e REGEXP"
)

testArray=(
    "./rsfind"
    "./rsfind ."
    "./rsfind ./dossier_test1"
    "./rsfind ./dossier_test1/dossier_test2"
    "./rsfind /builds/Pierre-Louis.Laurent/rs2018-gadeyne-laurent"
    
    "./rsfind --name NULL"
    "./rsfind --name fichier_test_1_1.txt"
    "./rsfind ./dossier_test1 --name fichier_test_1_1.txt"
    "./rsfind ./dossier_test3 --name NULL"
    "./rsfind ./dossier_test3 --name fichier_test_1_1.txt"
    
    #"./rsfind --print"
    #"./rsfind ./dossier_test3 --print"
    
    "./rsfind . -t NULL"
    "./rsfind . -t dirent.h"
    "./rsfind . -t 1_"
    "./rsfind ./dossier_test3 -t NULL"
    "./rsfind ./dossier_test3 -t 1"
    
    "./rsfind -i"
    "./rsfind ./dossier_test3 -i"
    
    #"./rsfind ./.git -l"
    #"./rsfind ./dossier_test3 -l"
    #"./rsfind /usr/bin -l"
    
    "./rsfind ./dossier_test3 --exec 'head {}'" 
    #"./rsfind DOSSIER --exec 'COMMANDE'"
    

    "./rsfind ./dossier_test3 -i"
    "./rsfind --name azertyuiop -i"
    "./rsfind --name 2h6nlob8uzq11 -i"
    "./rsfind --name 2h6nlob8uzq11.jpg -i"
    
    "./rsfind ./dossier_test3 --print --exec 'head {}'"
    #"./rsfind DOSSIER --print --exec 'COMMANDE'"
    
    #"./rsfind DOSSIER --ename REGEXP"
    #"./rsfind DOSSIER --ename REGEXP"
    
    #"./rsfind DOSSIER -T REGEXP"
    #"./rsfind DOSSIER -T REGEXP"
)

rm -rf *.o

touch truth.txt #On crée les fichiers qui vont contenir les valeurs de retour
touch test.txt #de nos commandes, au cas où elles seraient appelées dans le
#répertoire courant


#Création d'une structure de test
mkdir dossier_test1
cd dossier_test1
touch fichier_test_1_1.txt fichier_test_1_2.txt
mkdir dossier_test2
cd dossier_test2
touch fichier_test_2_1.txt fichier_test_2_2.txt
cd ..
cd .. #Retour au répertoire initial
mkdir dossier_test3
cd dossier_test3
touch fichier_test_3_1.txt fichier_test_3_2.txt
cd .. #Retour au répertoire initial

let "longueur1 = ${#truthArray[@]}"
let "longueur2 = ${#testArray[@]}"

error=0

if [ $longueur1 != $longueur2 ] #Vérification de la longueur des vecteurs des
   #commandes à exécuter
   
then
    printf "Erreur sur les longueurs des vecteurs\n"
    exit 1

else
    let "longueur = longueur1 - 1"
    
    for i in `seq 0 $longueur` #Parcours des éléments des vecteurs
    
    do
        eval ${truthArray[$i]} > truth.txt #Appels des commandes
        eval ${testArray[$i]} > test.txt
        
        e_code=$? #Code renvoyé par les appels ci-dessus
        
        if [ $e_code != 0 ] #Vérification de l'exécution correcte des tests
        
        then
            printf "Test %d failed : %d\n" "$i" "$e_code"
            exit 1
        
        else
            difference=`diff --text truth.txt test.txt`
            longueur_difference=${#difference}
            
            if [ $longueur_difference != 0 ] #Vérification de la validité des tests
                then
                printf "Test %d passé mais échec concernant la valeur du test\n" "$i"
                printf "%s != %s\n" "${truthArray[$i]}" "${testArray[$i]}"
                printf "%s\n" "$difference"
                error=1
            else
                printf "Test %d passé et résultat correct\n" "$i"
            fi
            printf "\n"
        fi
    done
fi

printf "Fin des tests\n"

rm truth.txt test.txt
rm -r dossier_test1 dossier_test3

if [ $error = 1 ]
then
    exit 1
else
    exit 0
fi

