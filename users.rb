
class UsersDatabase
  attr_reader :users

  def initialize
    @users = [
      { username: "guest1", role: "guest" },
      { username: "member1", role: "member", password: "secret123" }
      #{ username: "member2", role: "member", password: "pass456" }
    ]
  end
  
  def login(username, role, password = nil)
    user = @users.find { |u| u[:username] == username && u[:role] == role }
    if user
      if role == "member"
        if user[:password] == password
          puts "✅ Member login successful!"
          return user
        else
          puts "❌ Incorrect password for member."
          return nil
        end
      else
        puts "✅ Guest login successful!"
        return user
      end
    else
      puts "❌ User not found."
      nil
    end
  end
end