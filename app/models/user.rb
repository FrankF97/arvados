class User < OrvosModel
  include AssignUuid
  include KindAndEtag
  include CommonApiTemplate
  serialize :prefs, Hash
  has_many :api_client_authorizations
  before_update :prevent_privilege_escalation

  api_accessible :superuser, :extend => :common do |t|
    t.add :email
    t.add :full_name
    t.add :first_name
    t.add :last_name
    t.add :identity_url
    t.add :is_admin
    t.add :prefs
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  protected

  def prevent_privilege_escalation
    if self.is_admin_changed?
      if current_user.uuid == self.uuid
        if self.is_admin != self.is_admin_was
          self.is_admin = self.is_admin_was
        end
      end
    end
    true
  end
end
