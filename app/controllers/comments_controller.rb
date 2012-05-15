class CommentsController < ApplicationController

 before_filter :login_check
 before_filter :find_sale_and_visible

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.sale_id = @sale.id
    @comment.user_id = session[:user_id]
    if @comment.save
      redirect_to(sale_path(@sale), :notice => 'Comment was successfully posted.')
    else
      render :action => "new"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to(comments_url)
  end

  def find_sale_and_visible
     @sale = Sale.find_by_id(params[:sale_id])
     unless @sale && (@sale.visible) && @sale.active
       flash[:error] = "Sale you are trying to access doesn't exists."
       return redirect_to sales_path
     end
   end
end

