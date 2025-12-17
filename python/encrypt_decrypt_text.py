"""
-English
-lowercase

funcs:
- create and return a new random key.
- convert an existing key (make a decryption key from an encryption key)
  accepts an encryption key and returns a decryption key
- encrypt/decrypt:
        Accepts: 1 - text  2 -key
        returns: new text
- test_all:
creates a key
encrypts some text
convert the key
decrypts the text

ONE LINE CALLS THE test_all func.

Encryption Key:
a b c d e f g h i j k l m n o p q r s t u v w x y z
p f g a m     y       x     j

Decryption Key:
a b c d e f g h i j k l m n o p q r s t u v w x y z
d         b c     o     e     a               l h
"""
import random
from random import shuffle


def create_encryption_key():
    abc_list = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    abc_list2 = random.sample(abc_list, k=len(abc_list))
    encryption_key = {}
    for i in range(len(abc_list)):
        encryption_key[abc_list[i]] = abc_list2[i]
    encryption_key[" "] = " " # This line makes using SPACE possible. creating the possibility to use more than 1 word.

    return encryption_key


def create_decryption_key(encryption_key):

    decryption_key = {}
    for letter in encryption_key:
        decryption_key[encryption_key[letter]] = letter

    return decryption_key


def encoded_text(key, string):
    new_word=""
    for letter in string:
        new_word += key[letter]

    return new_word


def execute_func():
    encryption_key = create_encryption_key()
    decryption_key = create_decryption_key(encryption_key)
    print("Welcome to the text encryption program!\n")
    def menu():
        text =input("Press 'e' to see the Encryption key.\n"
                         "Press 'd' to see the Decryption key.\n"
                           "Press 'g' to generate a new pair of Encryption/Decryption keys.\n"
                           "Press 't' to write a text. you will see the Encrypted text.\n"
                          "Press 'q' to quit the program.\n"
                          "Your Choice: ").lower()
        return text
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
            encrypted_text= encoded_text(encryption_key, string=input("Please write a text in english, only lowercase letters: "))
            print(encrypted_text)
            user_input = menu()

execute_func()
