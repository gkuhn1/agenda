class Admin::DashboardController < Admin::AdminController
  def index
    @data = {
      accounts_count: Account.count,
      users_count: User.count,
    }
  end
end