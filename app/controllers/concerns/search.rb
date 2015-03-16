module Search
  extend ActiveSupport::Concern

  def search
    index
    render :index
  end
end
