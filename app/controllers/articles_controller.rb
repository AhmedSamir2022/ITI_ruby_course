class ArticlesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @articles = Article.where(archived: false)
  end

  def show; end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "Article created!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated!"
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted!"
  end

  def report
    @article.increment!(:reports_count)
    redirect_to articles_path, notice: "Reported!"
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_user!
    redirect_to articles_path, alert: "Not authorized!" unless @article.user == current_user
  end

  def require_login
    redirect_to login_path unless current_user
  end

  def article_params
    params.require(:article).permit(:title, :body, :image)
  end
end
