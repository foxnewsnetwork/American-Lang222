module PagesHelper
  
  # dataset is an hash of known information about a person
  # Generates #n permutations that most likely will cover a given person's email
  def GenerateBCCField( dataset , limit = 300 )
    addresses = []
    
    # Set 0: generating initials permutation
    useset = []
    useset += dataset[:firstname][0] unless dataset[:firstname].nil?
    useset += dataset[:middlename][0] unless dataset[:middlename].nil?
    useset += dataset[:lastname][0] unless dataset[:lastname].nil?
    addresses += self.PermuteAll(useset) unless useset.nil?
    
    # Set 1: generating first-middle initials last name permutations
    useset = []
    first_middle = []
    first_middle += dataset[:firstname][0] unless dataset[:firstname].nil?
    first_middle += dataset[:middlename][0] unless dataset[:middlename].nil?
    useset += [first_middle] unless first_middle.nil?
    useset += dataset[:lastname] unless dataset[:lastname].nil?
    addresses += self.PermuteAll(useset) unless useset.nil?
    
    # Set 2: generating middle-last initials first name permutations
    useset = []
    middle_last = []
    middle_last +=  dataset[:middlename][0] unless dataset[:middlename].nil?
    middle_last += dataset[:lastname][0] unless dataset[:lastname].nil?
    useset += [middle_last] unless middle_last.nil?
    useset += dataset[:firstname] unless dataset[:firstname].nil?
    addresses += self.PermuteAll(useset) unless useset.nil?
    
    # Set 3: generating full name permutations
    useset = []
    useset += dataset[:firstname] unless dataset[:firstname].nil?
    useset += dataset[:middlename] unless dataset[:middlename].nil?
    useset += dataset[:lastname] unless dataset[:lastname].nil?
    addresses += self.PermuteAll(useset) unless useset.nil?
    
    # Set 4: repeating steps 0-3 now with dates
    dates = []
    dates = dataset[:dates] unless dataset[:dates].nil?
    nominal_addresses = Array.new(addresses)
    dates.each do |date|
      year = []
      monthday = []
      year = "#{date.year}"[-2..-1]
      monthday = "#{date.month}#{date.day}"
      lolcat = Array.new(nominal_addresses)
      happycat = Array.new(nominal_addresses)
      for k in 0..lolcat.count-1 do
        lolcat[k] += year
        happycat[k] += monthday
      end
      addresses += lolcat + happycat
    end
    
    # Set 5: attaching domains
    domains = dataset[:domains].nil? ? [] : dataset[:domains]
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
  
  private
    # returns a string array of every single permutation of the elements in arr_in
    # Necessarily returns an array of size n!
    def self.PermuteAll( arr_in )
      return arr_in if arr_in.count <= 1
      
      arr_out = []
      for k in 0..arr_in.count-1 do
        recurse = Array.new(arr_in)
        recurse.delete_at(k)
        temp = self.PermuteAll( recurse )
        for j in 0..temp.count-1 do
          arr_out += [arr_in[k] + temp[j]]
        end
      end
      return arr_out
    end
end
