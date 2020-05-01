from random import randint
from sys import exit

game_over = '''
That's not a number! 
If you don't want to follow the rules then...
        ╔═╗╔═╗╔╦╗╔═╗  ╔═╗╦  ╦╔═╗╦═╗
        ║ ╦╠═╣║║║║╣   ║ ║╚╗╔╝║╣ ╠╦╝
        ╚═╝╩ ╩╩ ╩╚═╝  ╚═╝ ╚╝ ╚═╝╩╚═ 
'''
victory = '''
Congrats! You've just won nothing!
        ╦  ╦╦╔═╗╔╦╗╔═╗╦═╗╦ ╦
        ╚╗╔╝║║   ║ ║ ║╠╦╝╚╦╝
         ╚╝ ╩╚═╝ ╩ ╚═╝╩╚═ ╩    
'''

if __name__ == '__main__':
    number = randint(0,100)
    user_nuber = int
    print("Try to gues the number from 0 to 100, you meatbag!")
    while number != user_nuber:
        user_input = input("input number\n")
        try:
            user_nuber = int(user_input)
        except ValueError as e:
            print(game_over,e)
            exit(1)

        if number not in range(0,100):
            print("That's not fare! your number is out of the scope")
        if user_nuber == number:
            print(victory)
            break
        elif user_nuber > number:
            print("Hey big boy, try something lower!!!")
        elif user_nuber < number:
            print("Dont be so shy and try something greater")
