module Forge
  module Controllers
    module Posts
      def get_archive_months
        @months = Post.get_archive_months
      end

      def get_post_categories
        @post_categories = PostCategory.all(:order => :title)
      end
    end
  end
end