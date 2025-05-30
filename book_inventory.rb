require 'json'

class Book
    attr_accessor :title, :auther, :isbn, :count

    def initialize(title, auther, isbn, count = 1)
        @title = title
        @auther = auther
        @isbn = isbn
        @count = count
    end

    def to_hash
        {
            title: @title,
            auther: @auther,
            isbn: @isbn,
            count: @count
        }
    end

    def self.from_hash(hash)
        Book.new(hash['title'], hash['author'], hash['isbn'], hash['count'])
    end

end

class Inventory
    FILE_PATH = 'books_db.json'

    def initialize
        @books = load_books
    end

    
  def list_books
    if @books.empty?
      puts "No books in inventory."
    else
      sorted_books.each do |book|
        puts "#{book.title} by #{book.author} - ISBN: #{book.isbn} (Count: #{book.count})"
      end
    end
  end

  def add_book(title, author, isbn)
    return puts "Invalid input. Title, author, and ISBN cannot be empty." if [title, author, isbn].any?(&:empty?)

    existing_book = find_by_isbn(isbn)
    if existing_book
      existing_book.count += 1
      existing_book.title = title if existing_book.title != title
      existing_book.author = author if existing_book.author != author
    else
      @books << Book.new(title, author, isbn)
    end
    save_books
    puts "Book added successfully."
  end

  def remove_book(isbn)
    return puts "Invalid ISBN." if isbn.empty?

    book = find_by_isbn(isbn)
    if book
      @books.delete(book)
      save_books
      puts "Book removed."
    else
      puts "Book not found."
    end
  end

  def search_books(query)
    results = @books.select do |book|
      [book.title, book.author, book.isbn].any? { |field| field.downcase.include?(query.downcase) }
    end

    if results.empty?
      puts "No matching books found."
    else
      results.each do |book|
        puts "#{book.title} by #{book.author} - ISBN: #{book.isbn} (Count: #{book.count})"
      end
    end
  end

   
    private

    def sorted_books
        @books.sort_by(&:isbn)
    end

    def find_by_isbn(isbn)
        @books.find { |book| book.isbn == isbn }
    end

    def load_books
        data = JSON.parse(File.read(FILE_PATH))
        data.map { |book_hash| Book.from_hash(book_hash) }
    rescue
        []
    end

    def save_books
        File.write(FILE_PATH, JSON.pretty_generate(@books.map(&:to_hash)))
    end
end
