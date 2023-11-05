#! /bin/bash
echo " --------------------------"
echo "User Name: Cho Yui"
echo "Student Number: 12224391"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a 
specific 'movie id' from 'u.item'"
echo "2. Get the data of ‘action’ genre movies from 
'u.item’"
echo "3. Get the average 'rating’ of the movie 
identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item’"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 
'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by 
users with 'age' between 20 and 29 and 
'occupation' as 'programmer'"
echo "9. Exit"
echo " --------------------------"
while true
do
	read -p "Enter your choice [ 1-9 ]" choice
        case $choice in
	1)
		read -p "Please enter 'movie id' (1~1682): " id
		cat u.item | awk -F"|" -v id=$id '$1==id {print $0}'
		;;

	2)
		read -p "Do you want to get the data of ‘action’
genre movies from 'u.item’?(y/n):" ans
                if [ "$ans" = "y" ];then
			cat u.item | awk -F"|" '$7=="1" {print $1" "$2}' | head

		fi
		echo " "
		;;
	3)
                read -p "Please enter the 'movie id’(1~1682):" id
                cat u.data | awk -v id=$id '$2==id {sum+=$3; count++} END {printf "average rating of %u: %.5f\n",id,sum/count}'
                echo " "
                ;;

        4)
                read -p "Do you want to delete the ‘IMDb
URL’ from ‘u.item’?(y/n):" ans
                if [ "$ans" = "y" ]; then
                        cat u.item | sed 's/|http[^|]*|/||/' | head
                fi
                echo " "
                ;;

        5)
                read -p "Do you want to get the data about users
from ‘u.user’?(y/n):" ans
                if [ "$ans" = "y" ]; then
                        cat u.user | sed -E -e 's/([0-9]+)\|([0-9]+)\|M\|(.*)\|([0-9]+)/user \1 is \2 years old male \3/' -e 's/([0-9]+)\|([0-9]+)\|F\|(.*)\|([0-9]+)/user \1 is \2 years old female \3/' | head
                fi
                echo " "
                ;;

        6)
                read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n):" ans
                if [ "$ans" = "y" ]; then
                        cat u.item | sed -E -e 's/([0-9]+)-Jan-([0-9]+)/\201\1/' -e 's/([0-9]+)-Feb-([0-9]+)/\202\1/' -e 's/([0-9]+)-Mar-([0-9]+)/\203\1/' -e 's/([0-9]+)-Apr-([0-9]+)/\204\1/' -e 's/([0-9]+)-May-([[0-9]+)/\205\1/' -e 's/([0-9]+)-Jun-([0-9]+)/\206\1/' -e 's/([0-9]+)-Jul-([0-9]+)/\207\1/' -e 's/([0-9]+)-Aug-([0-9]+)/\208\1/' -e 's/([0-9]+)-Sep-([0-9]+)/\209\1/' -e 's/([0-9]+)-Oct-([0-9]+)/\210\1/' -e 's/([0-9]]+)-Nov-([0-9]+)/\211\1/' -e 's/([0-9]+)-Dec-([0-9]+)/\212\1/' | tail

                fi
                echo " "
                ;;

        7)
                read -p "Please enter the ‘user id’(1~943):" id
                list_mv=$(cat u.data | awk -v id=$id '$1==id {print $2}' | sort -n | tr '\n' '|' | sed 's/|$//')
                echo $list_mv
                echo " "
                for i in $(seq 1 10); do
                        mi=$(echo $list_mv | awk -F"|" -v i=$i '{print $i}')
                        cat u.item | awk -F"|" -v mi=$mi '$1==mi {print $1"|"$2}'
                done
                echo " "
                ;;

        8)
                read -p "Do you want to get the average 'rating' of
movies rated by users with 'age' between
20 and 29 and 'occupation' as 'programmer'?(y/n):" ans
                if [ "$ans" = "y" ];then
                        id_list=$(cat u.user | awk -F"|" '20<=$2 && $2<30 && $4=="programmer" {print $1}')
                         nf=$(echo $id_list | awk '{print NF}')

                        for i in $(seq 1 1655); do
                                count=0
                                total=0
                                new_list=$(cat u.data | awk -v i=$i '$2==i {print $1, $3}')
                                new_nf=$(echo $new_list | awk '{print NF}')

                                for j in $(seq 1 $nf); do

                                        id_in=$(echo $id_list | awk -v j=$j '{print $j}')

                                        for k in $(seq 1 $new_nf); do
                                                if [ `expr $k % 2` -eq 1 ]; then
                                                        add=$(echo $new_list | awk -v k=$k -v id_in=$id_in '$k -eq id_in {print $((k+1))}')

                                                        total=$((total+add))
                                                        count=$((count+1))

                                                fi

                                        done

                                avg=$((total/count))
                                avg_result=$(echo $avg | awk '{printf("%.5f \n",$1)}')
                                echo $i $avg_result

                                done

                        done
		fi
		echo " "
		;;

	9)
		echo "Bye!"
		exit 0;;
esac
done

	
