class PagesController < ApplicationController
  def home
    unless params[:address].nil?
      keywords = []
      params[:address].each do |key value|
        keywords.push(value)
      end
      @addresses = GenerateBCCField(keywords)
    end
  end

  def about
  end

  def feedback
  end

end
