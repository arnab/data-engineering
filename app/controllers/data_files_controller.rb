class DataFilesController < ApplicationController
  def new
    @data_file = DataFile.new
  end

  def create
    @data_file = DataFile.new(params[:data_file])
    if @data_file.valid?
      flash.now[:success] = "Your file was successfully imported!"
      render 'show'
    else
      render 'new'
    end
  end
end
