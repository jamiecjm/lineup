User.create(name:"employee",email:"employee@gmail.com",position: "Employee",department: 1,manager_id: 3, private_token: "employee",total_leafe_id:1,remaining_leafe_id:1,password: "employee@gmail.com")
User.create(name:"hr",email:"hr@gmail.com",position: "Employee",department: 0,manager_id: 3, private_token: "hr",total_leafe_id:2,remaining_leafe_id:2,password: "hr@gmail.com")

ActiveRecord::Base.transaction do
  40.times do |t|
  	user = User.new
  	user[:name] = Faker::Name.name
  	user[:email] = Faker::Internet.email
  	user[:department] = rand(0..2)
    user[:position] = rand(0..1)
  	user[:manager_id] = rand(3..42)
  	user[:phone_no] = Faker::PhoneNumber.cell_phone
  	user[:address] = Faker::Address.street_address
  	user[:private_token] = user[:email]
  	user[:total_leafe_id] = t+1
    user[:remaining_leafe_id] = t+1
  	user.save
  	user.update(password: "abc")
  end
end

ActiveRecord::Base.transaction do
  100.times do |t|
  	leafe = Leafe.new
  	leafe[:user_id] = rand(1..42)
  	leafe[:manager_id] = User.find(leafe[:user_id]).manager_id
  	leafe[:leave_type] = rand(0..5)
  	leafe[:leave_reason] = Faker::Hipster.sentence
  	leafe[:status] = rand(0..2)
  	leafe[:rejection_reason] = Faker::Hipster.sentence
  	leafe[:start_date] = Faker::Date.between_except(1.year.ago, 1.year.from_now, Date.today)
  	leafe[:end_date] = leafe[:start_date]+rand(1..3)
  	leafe[:total_days] = leafe.weekdays
  	leafe.save
  end
end

ActiveRecord::Base.transaction do
  42.times do |t|
  	total_leafe = TotalLeafe.new
  	total_leafe[:user_id] = t+1
  	total_leafe[:annual] = rand(0..10)
  	total_leafe[:maternity] = rand(0..10)
  	total_leafe[:non_paid] = rand(0..10)
  	total_leafe[:study] = rand(0..10)
  	total_leafe[:sick] = rand(0..10)
  	total_leafe[:emergency] = rand(0..10)
  	total_leafe.save
  end
end

ActiveRecord::Base.transaction do
  42.times do |t|
    remaining_leafe = RemainingLeafe.new
    remaining_leafe[:user_id] = t+1
    user = User.find(t+1)
    total_leafe = TotalLeafe.find(t+1)
    leaves = user.leaves.where(status: "Approved")
    remaining_leafe[:annual] = total_leafe.annual-leaves.where(leave_type: "Annual").sum(:total_days)
    remaining_leafe[:maternity] = total_leafe.maternity-leaves.where(leave_type: "Maternity").sum(:total_days)
    remaining_leafe[:non_paid] = total_leafe.non_paid-leaves.where(leave_type: "Non_paid").sum(:total_days)
    remaining_leafe[:study] = total_leafe.study-leaves.where(leave_type: "Study").sum(:total_days)
    remaining_leafe[:sick] = total_leafe.sick-leaves.where(leave_type: "Sick").sum(:total_days)
    remaining_leafe[:emergency] = total_leafe.emergency-leaves.where(leave_type: "Emergency").sum(:total_days)
    remaining_leafe.save
  end
end