
import random
from random import shuffle


def create_encryption_key():
    abc_list = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    abc_list2 = random.sample(abc_list, k=len(abc_list))
    encryption_key = {}
    for i in range(len(abc_list)):
        encryption_key[abc_list[i]] = abc_list2[i]

    return encryption_key


def create_decryption_key(encryption_key):

    decryption_key = {}
    for letter in encryption_key:
        decryption_key[encryption_key[letter]] = letter

    return decryption_key


def encoded_text(key, string):
    new_word=""
    misc_list = [' ', '.', ',', '?', '!', '(', ')','-',':']
    for letter in string:
        if letter in misc_list:
            new_word += letter
        else:
            new_word += key[letter.lower()]

    return new_word


def execute_func():
    encryption_key = create_encryption_key()
    decryption_key = create_decryption_key(encryption_key)
    print("Welcome to the text encryption program!\n")

    def menu():
        choice =input("Press 'e' to see the Encryption key.\n"
                         "Press 'd' to see the Decryption key.\n"
                           "Press 'g' to generate a new pair of Encryption/Decryption keys.\n"
                           "Press 't' to write a text. you will later choose to encrypt or decrypt it.\n"
                          "Press 'q' to quit the program.\n"
                          "Your Choice: ").lower()
        return choice

    user_input = menu()
    while user_input != 'q':
        if user_input == 'e':
            print(str(encryption_key).strip("{"+"}").replace(",","\n").replace(" ","").replace("'", " "))
            user_input = menu()
        elif user_input == 'd':
            print(str(decryption_key).strip("{"+"}").replace(",","\n").replace(" ","").replace("'", " "))
            user_input = menu()
        elif user_input == 'g':
            encryption_key = create_encryption_key()
            decryption_key = create_decryption_key(encryption_key)
            print("New Encryption and Decryption keys generated successfully!\n")
            user_input = menu()
        elif user_input == 't':
            enc_dec = input("Press 'e' to Encrypt text.\n"
                            "Press 'd' to Decrypt text.\n"
                            "Your Choice: ")
            if enc_dec == 'e':
                encrypted_text= encoded_text(encryption_key, string=input("Please write a text to encrypt: "))
                print('\n'+encrypted_text+'\n')
                user_input = menu()
            elif enc_dec == 'd':
                encrypted_text = encoded_text(decryption_key, string=input("Please write a text to decrypt: "))
                print('\n'+encrypted_text+'\n')
                user_input = menu()
            else:
                print("Please try again.")
                continue

execute_func()
