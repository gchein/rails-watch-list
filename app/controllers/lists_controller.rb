class ListsController < ApplicationController
  before_action :set_list, only: %i[show]
  def index
    @lists = List.all
    @list = List.new
  end

  def show
    @bookmarks = @list.bookmarks
    @bookmark = Bookmark.new
  end

  def create
    @list = List.new(list_params)

    if @list.save
      redirect_to lists_path
    else
      @lists = List.all
      render :index, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_list
    @list = List.find(params[:id])
  end
end
