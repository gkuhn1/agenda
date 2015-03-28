class Admin::UsersController < Admin::HomepagesController

  add_breadcrumb "Usuários", :admin_users_path

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
