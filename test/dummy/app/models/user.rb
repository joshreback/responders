class User < ActiveRecord::Base
  before_destroy do
    if name == "Undestroyable"
      errors.add(:base, "is Undestroyable")
      false
    end
  end
end
