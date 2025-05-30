require_relative 'book_inventory'

def main_menu
  inventory = Inventory.new

  loop do
    puts "\nBook Inventory Menu"
    puts "1. List Books"
    puts "2. Add Book"
    puts "3. Remove Book by ISBN"
    puts "4. Search Books"
    puts "5. Exit"
    print "Choose an option: "

    case gets.chomp
    when "1"
      inventory.list_books
    when "2"
      print "Enter title: "
      title = gets.chomp
      print "Enter author: "
      author = gets.chomp
      print "Enter ISBN: "
      isbn = gets.chomp
      inventory.add_book(title, author, isbn)
    when "3"
      print "Enter ISBN to remove: "
      isbn = gets.chomp
      inventory.remove_book(isbn)
    when "4"
      print "Enter search query: "
      query = gets.chomp
      inventory.search_books(query)
    when "5"
      puts "Exiting."
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

main_menu
