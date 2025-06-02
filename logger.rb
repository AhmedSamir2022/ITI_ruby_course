require 'time'

module Logger
  def log_info(message)
    File.open('app.logs', 'a') do |f|
      f.puts "#{Time.now.iso8601} -- info -- #{message}"
    end
  end

  def log_warning(message)
    File.open('app.logs', 'a') do |f|
      f.puts "#{Time.now.iso8601} -- warning -- #{message}"
    end
  end

  def log_error(message)
    File.open('app.logs', 'a') do |f|
      f.puts "#{Time.now.iso8601} -- error -- #{message}"
    end
  end
end

class User
  attr_reader :name
  attr_accessor :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transactions, &block)
    raise NotImplementedError, "This is an abstract method"
  end
end

class CBABank < Bank
  include Logger

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &block)

    transaction_desc = transactions.map { |t| "#{t.user.name} transaction with value #{t.value}" }.join(', ')
    log_info("Processing Transactions #{transaction_desc}")

    transactions.each do |transaction|
      begin
        unless @users.include?(transaction.user)
          raise StandardError, "#{transaction.user.name} not exist in the bank!!"
        end

        new_balance = transaction.user.balance + transaction.value

        if new_balance < 0
          raise StandardError, "Not enough balance"
        end

        transaction.user.balance = new_balance

        log_info("User #{transaction.user.name} transaction with value #{transaction.value} succeeded")

        log_warning("#{transaction.user.name} has 0 balance") if new_balance == 0

        yield(:success, "User #{transaction.user.name} transaction with value #{transaction.value}")
      rescue StandardError => e
       
        log_error("User #{transaction.user.name} transaction with value #{transaction.value} failed with message #{e.message}")
        
        yield(:failure, "User #{transaction.user.name} transaction with value #{transaction.value} with reason #{e.message}")
      end
    end
  end
end

# Main execution
users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400)
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

# Clear existing log file
File.delete('app.logs') if File.exist?('app.logs')

bank = CBABank.new(users)
bank.process_transactions(transactions) do |status, message|
  puts "Call endpoint for #{status} of #{message}"
end