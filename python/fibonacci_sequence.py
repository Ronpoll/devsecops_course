num1 = 0
num2 = 1
while num1 < 200:
    print(num1, num2, end=" ")
    num1 = num1 + num2
    num2 = num1 + num2

"""
# OPTION 2 #
num1 = 0
num2 = 1
for count in range(20):
    print(num1, end=" ")
    num1, num2 = num2, num1 + num2
"""
