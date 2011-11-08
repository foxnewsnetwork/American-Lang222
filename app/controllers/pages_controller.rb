require 'date'

class PagesController < ApplicationController
  def home
    @addresses = {}
#<<<<<<< HEAD
    unless params[:address].nil?
#=======
    #if params[:address]
#>>>>>>> 60d94af6fe7f08e4ad7c9f2df91079c4ba2d59b2
      @s = params[:address]
      @s[:dates] = @s[:dates].split(',')
      unless @s[:dates].empty?
        for k in 0..@s[:dates].count-1 do
          puts(@s[:dates][k])
          processedDate = process_date(@s[:dates][k])
          @s[:dates][k] = process_date(@s[:dates][k])
        end
      end
      @s[:domains] = @s[:domains].split(',')
      @addresses = GenerateBCCField(@s)
      unless @s[:firstname].empty? || @s[:lastname].empty?
        for k in 0..(@addresses.count-1) do
          @addresses[k] = "#{@s[:firstname].capitalize} #{@s[:lastname].capitalize} <#{@addresses[k]}>" 
        end
      end
    end
  end

  def about
  end

  def feedback
  end

end
