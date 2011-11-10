require 'date'

class PagesController < ApplicationController
  def home
    @addresses = {}
    @addresses = session[:addresses] unless session[:addresses].nil?
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
          @addresses[k] = "\"#{@s[:firstname].capitalize} #{@s[:lastname].capitalize}\" <#{@addresses[k]}>" 
        end
      end
      subject = @s[:subject].nil? ? "Temporary testing content here" : @s[:subject]
      content = @s[:content].nil? ? "Temporary subject here" : @s[:content]
      
      session[:content] = content
      session[:subject] = subject
      @email_content = Process4Changes(session[:content], @s)
      @email_subject = Process4Changes(session[:subject], @s)
      
      @addresses.each do |address|
        mail = UserMailer.company_email(address, content, subject)
        mail.deliver()
      end
      
    end
    
  end

  def send_email

  end
  
  def about

  end

  def feedback
  end

end
