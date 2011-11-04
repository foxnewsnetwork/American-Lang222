def PermuteAll( arr_in )
  if arr_in.count <= 1
    return arr_in 
  end
  if arr_in.count == 2
    return [(arr_in[0]+arr_in[1]), (arr_in[1]+arr_in[0])]
  end
  out_arr = []
  
  for k in (0..arr_in.count-1) do
    recurse_arr = Array.new(arr_in)
    recurse_arr.delete_at(k)
    temp = PermuteAll(recurse_arr)
    for j in (0..temp.count-1) do
      out_arr.push("#{arr_in[k]}#{temp[j]}")
    end
  end
  return out_arr
end

t0 = ['a','b','c','d']
@t1 = PermuteAll(t0)
@t1.each do |v|
  puts v
end

