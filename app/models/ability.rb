class Ability
  include CanCan::Ability

  def initialize(user)

    if user.admin?
        can :manage, :all
    else
        can :read, :all

        can :manage, [Sample, Shipment,
                      Container, Address,
                      Protocol, ProtocolApplication, ProtocolParameter,
                      ProtocolParameterValue]

        can [:create, :generate, :fetch], Barcode
        can :update, User, :id => user.id
        can [:create, :update], ContainerType
    end
  end
end
