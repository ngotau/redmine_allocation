class AllocationController < ApplicationController
  before_filter :find_project
  menu_item :overview
  include RedmineAllocation::RedmineAllocation

  def by_project
    @projects = Project.visible.active.find :all,
                                            :conditions => @project.project_condition(true),
                                            :include => [:members => :user],
                                            :order => "#{Project.table_name}.lft"
    
  end

  def by_user
    @months = months
    inside_users = User.active.find :all,
                                     :select => "DISTINCT #{User.table_name}.*",
                                     :joins => { :members => :project },
                                     :conditions => @project.project_condition(true) << " AND #{User.table_name}.category = #{Person::STAFF}"
    inside_allocation = allocation_by_months(inside_users, @months)
    @allocation = [[:"allocation.label_inside_allocation", inside_allocation]]
  end
end
