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
          @addresses[k] = "#{@s[:firstname].capitalize} #{@s[:lastname].capitalize} <#{@addresses[k]}>" 
        end
      end
      subject = @s[:subject].nil? ? "Temporary testing content here" : @s[:subject]
      content = @s[:content].nil? ? "Temporary subject here" : @s[:content]
      
      session[:addresses] = @addresses
      session[:content] = content
      session[:subject] = subject
      session[:dataset] = @s
      @email_content = Process4Changes(session[:content], dataset)
      @email_subject = Process4Changes(session[:subject], dataset)
    end
    
  end

  def send_email
    if(session[:addresses].empty?)
      flash[:notice] = "You fucking moron, you need to generate the emails first"
    else
      dataset = session[:dataset]
      addresses = session[:addresses]
      content = Process4Changes(session[:content], dataset)
      subject = Process4Changes(session[:subject], dataset)
      mail = UserMailer.company_email(addresses, content, subject)
      mail.deliver()
      session[:addresses] = []
      flash[:success] = "#{subject}\n#{content}"
    end
    redirect_to("/")
  end
  
  def about

  end

  def feedback
  end

end
