class DataFilesController < ApplicationController
  def new
    @data_file = DataFile.new
  end

  def create
    @data_file = DataFile.new(params[:file])
    unless @data_file.valid?
      render 'new'
    end
  end
end
