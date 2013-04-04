class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Post
  
  def after_save(page)
    trash_cache
  end
  
  def after_destroy(page)
    trash_cache
  end
end