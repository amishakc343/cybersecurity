#!/bin/bash

Quit(){

		echo "quitting the program"

		exit

	}

rerun() {

	echo " Do you want to run the program again(yes/no): "

	read opt

	if [[ "$opt" == "yes" ]]; then

		automation

	elif [[ "$opt" == "n0" ]]; then

		echo "quitting the program"

		Quit

	else 

		echo "please enter valid option"

		rerun

	fi 

}

encryption() {

        echo "Do you have a file to encrypt or do you want to create a new file"

        echo -n "Input 'E' if the file exists or 'C' to create a new file: "

        read existsorcreate

        if [[ $existsorcreate == 'C' ]]; then

                echo -n "Enter the name of the file: "

                read file

                echo -n "Enter the content for the file: "

                read newfilecontent

                echo "$newfilecontent" > $file

        elif [[ $existsorcreate == 'C' ]]; then

                echo -n "Enter the file name: "

                read file

                echo "content of the file is: " 

                cat $file

	else 

		echo "enter valid input" 

		encryption 

     	  fi

	  check(){

        echo -n "In which file do you want to store the encrypted content: "

        read encryptedfile

	if [[ -f $encryptedfile ]]; then

		echo "File existss.."

		check

	fi

}

check

	echo "Would you prefer asymmetric encryption or symmetric encryption?"

	echo -n "press 'as' for asymmertic and 'sy' for symmertic enc: "

	read type

	if [[ $type == 'as' ]]; then

		echo "Now, encrypting the file"

		openssl genrsa -out privatekey 1024 >& /dev/null 

		openssl rsa -in privatekey -out publickey -pubout >& /dev/null

		openssl pkeyutl -encrypt -in $file -inkey publickey -pubin -out $encryptedfile 

		echo "'$file' is successfully encrypted to '$encryptedfile'"

		echo "Now, redirecting you to.."

		rerun

	elif [[ $type == 'sy' ]]; then

		echo -n "Enter your desired password for symmetric encryption "

		stty -echo

		read password

		stty echo

		echo ""

		echo "aes-128-cdc" > algorithms.txt

		echo "aria-128-cfb8" >> algorithms.txt

		echo "bf-cdc" >> algorithms.txt

		echo "des-ecb" >> algorithms.txt

		echo "des3" >> algorithms.txt

		cat -n algorithms.txt

		ch() {

			echo " which encrypting algorith do you want to use? "

			read algo

		lines=$(wc -l < algorithms.txt)

		lines=$(wc -l < ip.txt) #wordcount 

		if [ -z $algo ]; then #-z checks if the reading input is null

        		echo "null"

        		ch

		elif ! [[ $algo =~ ^[0-9]+$ ]]; then 

        		echo 'Invalid'

        		ch

		elif ! [ $algo -le $lines ]; then

		        echo "not in the system"

		        ch

		fi 

	}

		ch 

		number=$(sed -n $algo"p" algorithms.txt)

		openssl enc -$number -in $file -out $encryptedfile -k $password >& /dev/null 

		echo "succesfully encrypted: '$encryptedfile'"



		echo "Now, redirecting you to.."

		rerun

	else

		echo "Please enter correct input"

		encryption

	fi

}

decryption() { 

 echo -n "On which file do you want to perform decryption? "

                read decrypt

		if [[ -f $decrypt ]]; then

			echo -e " "

		else

                        echo "File not found .."

                        echo "please enter a correct file name."

                        decryption

                fi

		dec_check(){

                echo -n "where do you want to store the decrypted content? "

                read decryptedfile

		if [[ -f $decryptedfile ]]; then

			echo "File already exists.."

			echo "Please enter another name"

			dec_check

		fi

		}

	dec_check

                echo -n "Please enter 'as' if asymmetric key was used for encryption and 'sy' if symmetric key was used: "

                read key

                if [[ $key == 'as' ]]; then

                        openssl pkeyutl -decrypt -in $decrypt -out $decryptedfile -inkey privatekey 

			echo "Successfully decrypted."

                        echo "Content inside the decrpyted file $decryptedfile was: "

                        cat $decryptedfile 

			rerun

		 elif [[ $key == 'sy' ]]; then

                        echo -n "Enter the password: "

			stty -echo

                        read password

			stty echo

                        echo "" 

                        echo "Which algorithm was used during encryption? "

                        cat -n algorithms.txt

                        read algo

                        number=$(sed -n $algo"p" algorithms.txt)

                        openssl $number -d -in $decrypt -out $decryptedfile -k $password >& /dev/null 

			echo "Successfully Decrypted" 

                        echo "Content inside the decrypted file $decryptedfile was: "

                        cat $decryptedfile

                      	rerun 

		else 

			echo "enter valid input"

			rerun	

                fi  

}



automation() {

echo "do you want to perform encryption or decryption?"


echo -n "press 'Enc' for encryption, 'Dec' for decryption and 'Q' for quit: "

read initial_input

	if [[ $initial_input == "Enc" ]]; then 

		encryption

	elif [[ $initial_input == "Dec" ]]; then

		decryption

	elif [[ $initial_input == "Q" ]]; then

		Quit

	else

		echo "You have entered invalid option"

		automation 

	fi

}

automation



