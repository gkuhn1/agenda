class AgendaBreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder
  def compute_all_paths
    @elements.collect do |element|
      compute_path(element)
    end
  end
end