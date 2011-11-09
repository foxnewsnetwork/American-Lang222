require 'date'

class PagesController < ApplicationController
  def home
    @addresses = {}
    unless params[:address].nil?
      @s = params[:address]
      @s[:dates] = @s[:dates].split(',')
      unless @s[:dates].empty?
        for k in 0..@s[:dates].count-1 do
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
      mail = UserMailer.welcome_email(@addresses)
               mail.deliver()

    end
  end

  def send_email


  end
  def about

  end

  def feedback
  end

end
