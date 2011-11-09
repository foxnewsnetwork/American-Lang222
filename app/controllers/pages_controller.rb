require 'date'

class PagesController < ApplicationController
  def home
    @addresses = {}
    unless params[:address].blank?

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
      mail = UserMailer.welcome_email()
               mail.deliver()

    end
  end

  def send_email
    @addresses = params[:addresses]
    mail = UserMailer.welcome_email()
         mail.deliver()

  end
  def about
    mail = UserMailer.welcome_email()
         mail.deliver()

  end

  def feedback
  end

end
