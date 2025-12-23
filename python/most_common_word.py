

def read_book(book):
    book = open(book, encoding='utf8').read()
    return book

def clean_book(book):
    cleaned = book.lower().split()
    for i in range(len(cleaned)):
        word = cleaned[i].strip('.,:!@#$%^&*()-+=—?_”;“')
        cleaned[i] = word
    return  cleaned

def most_common_word (book):
    word_counter = {}
    counter = 0
    common_word = ""

    for word in book:
        word_counter[word] = 0

    for index in range(len(book)):
        if book[index] in word_counter:
            word_counter[book[index]]+=1

    for word in book:
        if word_counter[word] > counter:
            common_word = word
            counter = word_counter[word]

    return f'Most common word in text is: {common_word}\nNumber of times it is written: {counter}'

def main(book_to_check):
    book = read_book(book_to_check)
    cleaned = clean_book(book)
    print(most_common_word(cleaned))


main('Alice in Wonderland.txt')
