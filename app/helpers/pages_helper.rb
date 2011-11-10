require 'date'

module PagesHelper
  
  # dataset is an hash of known information about a person
  # Generates #n permutations that most likely will cover a given person's email

  def GenerateBCCField( dataset , limit = 300 )
    addresses = []
    
    # Set 0: generating initials permutation
    useset = []
    useset += [dataset[:firstname][0]] unless dataset[:firstname].empty?
    useset += [dataset[:middlename][0]] unless dataset[:middlename].empty?
    useset += [dataset[:lastname][0]] unless dataset[:lastname].empty?
    addresses += PermuteAll(useset) unless useset.empty?
    
    # Set 1: generating first-middle initials last name permutations
    useset = []
    first_middle = ""
    first_middle += dataset[:firstname][0] unless dataset[:firstname].empty?
    first_middle += dataset[:middlename][0] unless dataset[:middlename].empty?
    useset += [first_middle] unless first_middle.empty?
    useset.push(dataset[:lastname]) unless dataset[:lastname].empty?
    addresses += PermuteAll(useset) unless useset.empty?
    
    # Set 2: generating middle-last initials first name permutations
    useset = []
    middle_last = ""
    middle_last += dataset[:middlename][0] unless dataset[:middlename].empty?
    middle_last += dataset[:lastname][0] unless dataset[:lastname].empty?
    useset += [middle_last] unless middle_last.empty?
    useset.push(dataset[:firstname]) unless dataset[:firstname].empty?
    addresses += PermuteAll(useset) unless useset.empty?
    
    # Set 3: generating full name permutations
    useset = []
    useset.push(dataset[:firstname]) unless dataset[:firstname].empty?
    useset.push(dataset[:middlename]) unless dataset[:middlename].empty?
    useset.push(dataset[:lastname]) unless dataset[:lastname].empty?
    addresses += PermuteAll(useset) unless useset.empty?
    
    # Set 4: repeating steps 0-3 now with dates
    dates = []
    dates = dataset[:dates] unless dataset[:dates].empty?
    nominal_addresses = Array.new(addresses)
    dates.each do |date|
      #if it's not just a year, process it as normal'
      if date["month"] && date["day"]
      year = "#{date["year"]}"[-2..-1]
      monthday = "#{date["month"]}#{date["day"]}"
      lolcat = Array.new(nominal_addresses)
      happycat = Array.new(nominal_addresses)

      #putting in a full year to addresses as well.
      # I think it'd be common enough for people to put a full year in.'
      fullyear = "#{date["year"]}"
      additional_cat = Array.new(nominal_addresses)
      for k in 0..lolcat.count-1 do
        lolcat[k] += year
        happycat[k] += monthday
        additional_cat[k] += fullyear
      end
      addresses += lolcat + happycat + additional_cat

      #there is only a date. So process it as so
      else
       year = "#{date["year"]}"[-2..-1]
       #also note the full year rather than the last two digits
       fullyear = "#{date["year"]}"
       lolcat = Array.new(nominal_addresses)
      happycat = Array.new(nominal_addresses)
      for k in 0..lolcat.count-1 do
        lolcat[k] += year
       #make it so addresses can have the full year
        happycat[k] += fullyear
      end
      addresses += lolcat + happycat
        end
    end
    
    # Set 5: attaching domains
    domains = dataset[:domains].empty? ? [] : dataset[:domains]
    out_value = []
    domains.each do |domain|
      na = Array.new(addresses)
      for k in 0..addresses.count-1 do
        na[k] += "@#{domain}"
      end
      out_value += na
    end
    
    return out_value unless out_value.count > limit
    return out_value[0..limit-1]
  end
  
  # returns a string array of every single permutation of the elements in arr_in
  # Necessarily returns an array of size n!
  def PermuteAll( arr_in )
    return arr_in if arr_in.count <= 1
    
    arr_out = []
    for k in 0..arr_in.count-1 do
      recurse = Array.new(arr_in)
      recurse.delete_at(k)
      temp = PermuteAll( recurse )
      for j in 0..temp.count-1 do
        arr_out += [arr_in[k] + temp[j]]
      end
    end
    return arr_out
  end

  #Handle the entering of dates case by case.
  def process_date(date)
    #store our values in a hash, making it easier to access
    date_hash = Hash.new
     #if the date is only a year we'll process that
    if date.length == 4
      date_hash["year"] = "2011"

    #otherwise we'll process it as a normal date.We assume normal date formatting'
    else
       separated_date = date.split("-")
      date_hash["year"] = separated_date[0]
       #case incase they forget that month should be before day.
       #so if the "month" is greater than 12 we know the meant day instead
       if separated_date[1].to_i >12
         date_hash["month"] = separated_date[2].gsub("0","")
      date_hash["day"] = separated_date[1].gsub("0","")
       #else proceed as normal
       else
         date_hash["month"] = separated_date[1].gsub("0","")
      date_hash["day"] = separated_date[2].gsub("0","")
       end

    end


    return date_hash
   end
  
  # We ought to make additions to this function in the future so that we can handle more template usage 
  def Process4Changes(content, dataset)
    # update this hash in the future
    change_flags = { "[NAME]" => [:firstname] , "[FULLNAME]" => [:firstname, :lastname]}
    
    # Please don't do something stupid like setting someone's first name to [FULLNAME] or something
    change_flags.each do |key, value|
      replacement_string = ''
      value.each do |wolf|
        replacement_string += dataset[wolf] + " "
      end
      content = content.gsub(key, replacement_string)
    end
    return content
  end

end
