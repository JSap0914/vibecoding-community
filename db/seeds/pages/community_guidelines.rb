# VIBECODING CUSTOMIZATION - Epic 1, Story 1.6
# Community Guidelines Page Seed Data
# Creates the /community-guidelines page with behavior standards and moderation policy

guidelines_content = <<~MARKDOWN
  # Community Guidelines

  Welcome to Vibecoding Community! These guidelines help ensure our community remains a welcoming, productive space for everyone exploring AI-assisted development.

  ## Expected Behavior

  We're building a community where developers can learn, share, and grow together. To make that happen, we ask that all members:

  ### Be Respectful
  - Treat everyone with kindness and professionalism
  - Welcome newcomers and help them feel included
  - Disagree constructively—focus on ideas, not individuals
  - Respect diverse perspectives, backgrounds, and experience levels

  ### Be Constructive
  - Provide helpful, actionable feedback
  - Share knowledge generously
  - Ask questions that move conversations forward
  - Celebrate others' successes and progress

  ### Be Authentic
  - Share real experiences—both successes and challenges
  - Give credit where credit is due
  - Be transparent about affiliations and conflicts of interest
  - Admit when you don't know something

  ## Content Quality Standards

  We value **substantive content** that helps the community learn and grow:

  ### ✅ Great Content Includes:
  - **Project showcases** with technical details, lessons learned, or challenges overcome
  - **How-to guides** and tutorials based on real experience
  - **Thoughtful questions** that show you've done some research
  - **Well-explained problems** with context, attempts made, and specific blockers
  - **Constructive discussions** about vibecoding techniques, tools, and workflows

  ### ❌ Content to Avoid:
  - **Spam** or low-effort promotional posts
  - **Duplicate questions** without searching first
  - **Vague "help me" posts** without details or context
  - **AI-generated content** posted without review or attribution
  - **Off-topic discussions** unrelated to vibecoding or software development

  ## Self-Promotion Policy

  We encourage sharing what you're building, with some guidelines:

  ### ✅ Encouraged Self-Promotion:
  - **ANYON project showcases**: Share your ANYON projects freely—that's what we're here for!
  - **Vibecoding tool comparisons**: Honest reviews and experiences with different AI coding tools
  - **Open source projects**: Share projects that benefit the community
  - **Educational content**: Courses, tutorials, or resources you've created (if genuinely helpful)

  ### ⚠️ Limited Self-Promotion:
  - **Commercial products**: Allowed if they provide clear value to the community and aren't the only thing you post about
  - **Affiliate links**: Disclose them clearly
  - **Job postings**: Use appropriate tags and don't spam

  ### ❌ Not Allowed:
  - **Spam**: Repeated promotional posts with no community engagement
  - **Misleading marketing**: Fake reviews, astroturfing, or deceptive practices
  - **Unrelated products**: Things that have nothing to do with vibecoding or development

  **Rule of thumb**: If you're here to *give* to the community (share knowledge, help others, contribute), occasional self-promotion is welcome. If you're only here to *take* (extract leads, push products, drive traffic), that's spam.

  ## Moderation Policy

  Our moderation team works to keep the community healthy and productive. Here's how we handle guideline violations:

  ### 1️⃣ First Violation: **Friendly Warning**
  - We'll reach out privately to explain the issue
  - Post may be edited or removed if necessary
  - No lasting consequences for good-faith mistakes

  ### 2️⃣ Repeated Violations: **Temporary Suspension**
  - 3-7 day suspension from posting and commenting
  - Serious violations may skip to this step
  - Clear explanation of what needs to change

  ### 3️⃣ Continued Violations: **Permanent Ban**
  - Permanent removal from the community
  - Reserved for spam accounts, harassment, or repeated intentional violations

  ### Fast-Track to Ban:
  Some behaviors result in **immediate permanent bans**:
  - **Harassment** or personal attacks
  - **Hate speech** or discriminatory content
  - **Doxxing** or privacy violations
  - **Illegal content** or activity
  - **Automated spam** or bot behavior

  ## Consequences for Violations

  We believe in **progressive discipline** for most issues:

  - **Minor issues** (formatting, unclear posts): Gentle guidance, no formal action
  - **Moderate issues** (self-promotion overload, low-effort posts): Warning → Suspension if repeated
  - **Serious issues** (spam, rudeness, disrespect): Suspension → Ban if repeated
  - **Severe issues** (harassment, hate speech, illegal content): Immediate ban

  Our goal is **education, not punishment**. Most violations happen because people don't understand the guidelines or make honest mistakes. We'll work with you to help you become a positive community member.

  ## How to Report Issues

  If you see content or behavior that violates these guidelines:

  ### 1. **Flag the Post or Comment**
  - Click the "..." menu on any post/comment
  - Select "Report"
  - Choose the reason that best fits

  ### 2. **Contact Moderators Directly**
  - Email: **moderators@vibecoding.community**
  - Include a link to the problematic content
  - Briefly explain the issue

  ### 3. **For Urgent Issues**
  - Harassment, threats, or illegal content: **Email moderators@vibecoding.community immediately**
  - We monitor this email 24/7 for urgent safety issues

  **Privacy**: All reports are confidential. We never reveal who reported content unless legally required.

  ## Questions About These Guidelines?

  If something is unclear or you want to suggest improvements:
  - **Email**: hello@vibecoding.community
  - **Discussion**: Post in the [#meta](https://vibecoding.community/t/meta) tag

  These guidelines evolve as our community grows. We welcome your input!

  ---

  **By participating in Vibecoding Community, you agree to follow these guidelines.**

  *Thank you for helping us build a welcoming, productive community for vibecoding enthusiasts! 🚀*
MARKDOWN

# Create or update the Community Guidelines page
begin
  Page.find_or_initialize_by(slug: "community-guidelines").tap do |page|
    page.title = "Community Guidelines - Vibecoding Community"
    page.description = "Community guidelines for Vibecoding Community: expected behavior, content quality standards, self-promotion policy, moderation, and how to report issues."
    page.body_markdown = guidelines_content
    page.template = "contained"
    page.is_top_level_path = true
    page.landing_page = false
    page.save!

    puts "✓ Created/updated Community Guidelines page at /community-guidelines"
  end
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error("Failed to create/update Community Guidelines page: #{e.message}")
  puts "✗ Error creating Community Guidelines page: #{e.message}"
rescue StandardError => e
  Rails.logger.error("Unexpected error creating Community Guidelines page: #{e.message}")
  puts "✗ Unexpected error: #{e.message}"
  raise
end
