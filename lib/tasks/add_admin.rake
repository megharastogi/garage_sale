task :add_admin => :environment do
  require 'rubygems'
  require 'highline/import'

  print "Please enter your First Name:    "
  f_name = STDIN.gets
  while(f_name == "\n")
    print "Please enter your First Name:    "
    f_name = STDIN.gets
  end
  print "Please enter your Last Name:    "
  l_name = STDIN.gets
  while(l_name == "\n")
    print "Please enter your Last Name:    "
    l_name = STDIN.gets
  end 
  invalid_email =true;

  while(invalid_email)
    email = ask("Please enter your email address :    " )
    if email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
      user = User.where(["email = ?", email]).first
      unless user.nil?
        print "Email address already exists, "
      else
        invalid_email=false;
      end   
    end  
  end

  password=true
  confirm_password=false

  while(password!=confirm_password and password!="")  
    password = ask("Enter your password:  " ) { |q| q.echo = "*" }
    confirm_password = ask("Enter your password again:  " ) { |q| q.echo = "*" }
    if (password == "")
      print "Password cannot be blank.\n\n"    
    end

    if (password!=confirm_password and password!="")
      print "Password doesnot match.\n\n"
    end
  end

  user = User.new(:email=>email, :password=>password,:password_confirmation=>confirm_password,:account_type=> "admin", :first_name=>f_name,:last_name=>l_name,:terms => "1",:sex => "Female",:active => "1")
  if user.save(:validate=>false)
    print "Your account has been created \n"
  else
    print "There is some issue in creating your account \n"
  end
end
