class BookmarksController < ApplicationController
  before_action :set_parent_list, only: %i[new create]
  before_action :set_bookmark, only: %i[destroy]

  # def new
  #   @bookmark = Bookmark.new
  # end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    @bookmarks = @list.bookmarks

    if @bookmark.save
      redirect_to list_path(@list)
    else
      render template: "lists/show", status: :unprocessable_entity
    end
  end

  def destroy
    # @list = @bookmark.list
    @bookmark.destroy

    redirect_to list_path(@bookmark.list), status: :see_other
  end

  private

  def set_parent_list
    @list = List.find(params[:list_id])
  end

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
