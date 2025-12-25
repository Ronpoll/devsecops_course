def do_math(a, b):
    try:
        num = a/b
        return num
    except ZeroDivisionError:
        print("Can't divide by zero")




def provide_nums(a):
    for num in range(-5,6):
        result = do_math(a,num)
        print(result)

provide_nums(20)
