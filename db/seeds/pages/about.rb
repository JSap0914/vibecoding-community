# VIBECODING CUSTOMIZATION - Epic 1, Story 1.6
# About Page Seed Data
# Creates the /about page with mission statement, community details, and ANYON connection
#
# NOTE: Team introduction section (Subtask 1.6, AC-1.6.4) is intentionally omitted for MVP.
# Rationale: The community is in early launch phase. Adding team bios now would create
# maintenance overhead as the team structure is still evolving. This can be added in a
# future iteration when the team composition stabilizes.

about_page_content = <<~MARKDOWN
  # About Vibecoding Community

  ## Our Mission

  **Building the vibecoding movement** — a new way of developing software through natural language and AI collaboration.

  Vibecoding represents the future of software development, where developers express their intent in plain language and AI assistants help translate that into working code. We're here to explore, learn, and build together as this revolutionary approach transforms how we create software.

  ## What Makes This Community Special

  This isn't just another developer forum. Vibecoding Community is the **premier gathering place for developers exploring AI-assisted development**:

  - **Practical Focus**: Real projects, real challenges, real solutions
  - **Natural Language Development**: Learn to "vibe" with AI to build software faster and better
  - **Supportive Environment**: Whether you're taking your first steps with AI coding tools or pushing the boundaries of what's possible
  - **Knowledge Sharing**: Learn from others' successes and challenges with vibecoding workflows

  We believe that vibecoding is not about replacing developers—it's about **amplifying developer creativity and productivity**. Here, you'll find a community that understands this vision and is actively working to make it real.

  ## The ANYON Connection

  This community is built on [ANYON](https://anyon.com), the platform that's pioneering vibecoding as a development methodology. ANYON provides the tools and infrastructure that enable true natural language development—where you can build full-stack applications through conversation.

  While we're proud to showcase projects built with ANYON, this community welcomes **all vibecoding tools and approaches**. Whether you use ANYON, Claude Code, GitHub Copilot, Cursor, or any other AI-assisted development tool, you're welcome here. Our focus is on the **vibecoding methodology**, not just one platform.

  ## Get Involved

  Join us in shaping the future of software development:

  - **Share your projects**: Show what you're building with vibecoding
  - **Ask questions**: No question is too basic or too advanced
  - **Contribute knowledge**: Write tutorials, guides, and case studies
  - **Connect**: Find collaborators and mentors in the vibecoding space

  ## Contact Us

  - **Email**: hello@vibecoding.community
  - **GitHub**: [vibecoding-community](https://github.com/vibecoding-community)
  - **Twitter/X**: [@vibecoding](https://twitter.com/vibecoding)

  Have questions or feedback? We'd love to hear from you!

  ---

  *Ready to start building with vibecoding? [Join the community](/enter) and introduce yourself!*
MARKDOWN

# Create or update the About page
begin
  Page.find_or_initialize_by(slug: "about").tap do |page|
    page.title = "About Vibecoding Community - Our Mission"
    page.description = "Learn about the vibecoding movement, what makes our community special, and how we're building the future of AI-assisted software development."
    page.body_markdown = about_page_content
    page.template = "contained"
    page.is_top_level_path = true
    page.landing_page = false
    page.save!

    puts "✓ Created/updated About page at /about"
  end
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error("Failed to create/update About page: #{e.message}")
  puts "✗ Error creating About page: #{e.message}"
rescue StandardError => e
  Rails.logger.error("Unexpected error creating About page: #{e.message}")
  puts "✗ Unexpected error: #{e.message}"
  raise
end
