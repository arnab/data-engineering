class DataFilesController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create]

  def new
    @data_file = DataFile.new
  end

  def create
    @data_file = DataFile.new(params[:data_file])
    if @data_file.valid? && @data_file.import
      filename = params[:data_file][:data].original_filename
      flash.now[:success] = "Your file '#{filename}' was successfully imported!"
      render 'show'
    else
      render 'new'
    end
  end
end
