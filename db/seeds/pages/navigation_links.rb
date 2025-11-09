# VIBECODING CUSTOMIZATION - Epic 1, Story 1.6
# Navigation Links for About and Community Guidelines pages
#
# NOTE: Uses NavigationLink.create_or_update_by_identity method (verified in app/models/navigation_link.rb:41-43)
# This method is part of Forem's NavigationLink model and provides idempotent link creation/updating.

# SVG icon for Community Guidelines (using a shield/policy icon)
guidelines_icon = <<~SVG
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
    <path d="m9 12 2 2 4-4"></path>
  </svg>
SVG

# SVG icon for About (using an info icon)
about_icon = <<~SVG
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <circle cx="12" cy="12" r="10"></circle>
    <path d="M12 16v-4"></path>
    <path d="M12 8h.01"></path>
  </svg>
SVG

# Create or update About navigation link (main navigation)
begin
  NavigationLink.create_or_update_by_identity(
    url: "/about",
    name: "About",
    icon: about_icon.strip,
    section: "default",
    position: 10,
    display_to: "all"
  )
  puts "✓ Created/updated About navigation link"
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error("Failed to create/update About navigation link: #{e.message}")
  puts "✗ Error creating About navigation link: #{e.message}"
rescue StandardError => e
  Rails.logger.error("Unexpected error creating About navigation link: #{e.message}")
  puts "✗ Unexpected error: #{e.message}"
  raise
end

# Create or update Community Guidelines navigation link (footer - "other" section)
begin
  NavigationLink.create_or_update_by_identity(
    url: "/community-guidelines",
    name: "Community Guidelines",
    icon: guidelines_icon.strip,
    section: "other", # "other" section = footer navigation
    position: 4, # After Code of Conduct, Privacy, Terms
    display_to: "all"
  )
  puts "✓ Created/updated Community Guidelines navigation link"
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error("Failed to create/update Community Guidelines navigation link: #{e.message}")
  puts "✗ Error creating Community Guidelines navigation link: #{e.message}"
rescue StandardError => e
  Rails.logger.error("Unexpected error creating Community Guidelines navigation link: #{e.message}")
  puts "✗ Unexpected error: #{e.message}"
  raise
end
