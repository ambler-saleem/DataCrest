class Agents::InvitationsController < Devise::InvitationsController
  before_action :set_resource, only: [:update]

  def update
    @agency = self.resource.owned_agency
    super
    if resource.invitation_accepted_at?
      resource.wholesalers << resource.invited_by.wholesaler
      resource.agency_applications.update_all(agency_id: @agency.id) if resource.agency_applications.present?
      UserMailer.welcome(resource.email).deliver_later
      CompanyOwnerMailer.agent_invite_accept(resource).deliver_later
    end
  end

  private

    def update_resource_params
      params.require(:agent).permit(:password, :password_confirmation, :invitation_token, :profile_picture, :profile_picture_cache,
                                    owned_agency_attributes: [:id, :title, :city, :zip_code, :state, :website, :address_1,
                                    :address_2, :logo])
    end

    def set_resource
      redirect_to accept_agent_invitation_url(invitation_token: update_resource_params[:invitation_token]), alert: "Agency must exist" unless params[:agent][:owned_agency_attributes].present?
      self.resource = Agent.find_by_invitation_token(update_resource_params[:invitation_token], true)
    end

    def accept_resource
      resource_class.accept_invitation!(update_resource_params.merge!(agency: @agency))
    end
end
