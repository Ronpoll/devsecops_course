low = 0
high = 100

print("Think of a number between 0 and 100.")

while low < high:
    guess = (low + high) // 2
    answer = input(f"Is your number bigger than {guess}? (y/n): ").lower()

    if answer == "y":
        low = guess + 1
    elif answer == "n":
        high = guess
    else:
        print("Please answer with y or n.")

print(f"Your number is {low}!")
