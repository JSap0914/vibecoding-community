# Epic Technical Specification: Content Strategy & Community Launch

Date: 2025-11-09
Author: JSup
Epic ID: 4
Status: Draft

---

## Overview

Epic 4 establishes the content foundation and community engagement infrastructure for Vibecoding Community. This epic focuses on launching with high-quality seeded content, implementing a clear content taxonomy, providing templates for consistent content creation, and establishing moderation and notification systems to maintain quality and drive engagement.

The primary goal is to create immediate value for early adopters while setting quality standards that guide future community contributions. This includes configuring 10 core tags for vibecoding topics, creating 5 content templates, publishing 20+ high-quality posts before launch, implementing spam prevention, and establishing email notification systems for ongoing engagement.

## Objectives and Scope

**In Scope:**
- Tag taxonomy configuration with 10 core vibecoding tags (#vibecoding, #anyon, #project-showcase, #tutorial, #ai-development, #prompting, #maintenance, #lovable-alternative, #beginner, #advanced)
- Content template creation for 5 common post types (Project Showcase, Tutorial, Comparison, Technique, Weekly Roundup)
- Initial content seeding with 20+ team-authored posts demonstrating vibecoding value
- Content moderation infrastructure including rate limiting, spam prevention, and admin tools
- Email notification system with customizable subscriptions and branded templates
- Community guidelines and quality standards documentation

**Out of Scope:**
- Advanced gamification features (badges, points, leaderboards) - deferred to post-MVP
- User reputation systems - simplified version only
- Video hosting infrastructure - YouTube embeds only for MVP
- AI-powered content recommendations - manual curation for MVP
- Multi-language content support - English only for MVP
- Paid tier or subscription features - free community for MVP

**Success Metrics:**
- 10 core tags configured with descriptions and SEO optimization
- 5 content templates available in post editor
- 20+ seed posts published with mix of showcase, tutorial, and comparison content
- Rate limiting and spam prevention active on all user-generated content
- Email notification system operational with < 2% unsubscribe rate
- Zero spam posts reaching community within first 30 days

## System Architecture Alignment

This epic aligns with the brownfield customization strategy by leveraging Forem's built-in features for content management while adding vibecoding-specific configuration and seed data.

**Forem Features Utilized:**
- Tags system (existing) - configured with vibecoding taxonomy
- Article templates feature (existing) - populated with custom templates
- Content moderation tools (existing) - configured with vibecoding-specific rules
- Email notification system (existing - ActionMailer + Forem notification framework) - customized with branding and preferences
- Admin panel (existing) - used for configuration and moderation

**Custom Components:**
- Seed data scripts for initial content (`db/seeds/vibecoding_content.rb`)
- Community guidelines pages (Forem Pages feature)
- Custom email templates with vibecoding branding
- Tag usage analytics tracking

**Database Impact:**
- Minimal - uses existing Forem schema (articles, tags, users, notifications)
- Seed data only, no schema migrations required for this epic

## Detailed Design

### Services and Modules

This epic primarily uses Forem's existing services with configuration and seed data. No new custom services required.

**Forem Modules Utilized:**

| Module | Responsibility | Configuration | Owner |
|--------|---------------|---------------|-------|
| **Tag Management** | Tag CRUD, tag following, tag pages | Admin Panel > Tags | Content Strategist |
| **Article Templates** | Template storage, template selection in editor | Admin Panel > Article Templates | Content Strategist |
| **Moderation System** | Spam detection, content flagging, rate limiting | Admin Panel > Config > Community | Community Manager |
| **Notification System** | Email notifications, in-app notifications, preferences | Forem ActionMailer + Notification framework | DevOps Engineer |
| **Pages System** | Static pages (Community Guidelines, About) | Admin Panel > Pages | Content Strategist |
| **Seed Data Management** | Initial content creation | `db/seeds/vibecoding_content.rb` | Developer |

**Configuration Files:**

- `config/initializers/vibecoding_customizations.rb` - Tag rules, rate limiting, community settings
- `db/seeds/vibecoding_content.rb` - Seed posts, tags, templates
- `app/views/devise/mailer/*.html.erb` - Custom email templates with vibecoding branding

### Data Models and Contracts

**Existing Forem Models (No Schema Changes):**

**Tag Model:**
```ruby
# Existing Forem model - no changes
class Tag < ApplicationRecord
  # Fields used:
  # - name: string (e.g., "vibecoding", "anyon")
  # - short_summary: string (tag description)
  # - rules_html: text (tag usage guidelines)
  # - bg_color_hex: string (badge color)
  # - text_color_hex: string (badge text color)
  # - supported: boolean (featured tags)

  has_many :taggings
  has_many :articles, through: :taggings
end
```

**Article Model:**
```ruby
# Existing Forem model - no changes for this epic
class Article < ApplicationRecord
  # Fields used:
  # - title: string
  # - body_markdown: text
  # - user_id: bigint
  # - published: boolean
  # - tags: string (comma-separated)

  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings
end
```

**User Model:**
```ruby
# Existing Forem model - no changes
class User < ApplicationRecord
  # Notification preferences stored in:
  # - email_digest_periodic: boolean
  # - email_comment_notifications: boolean
  # - email_badge_notifications: boolean

  has_many :articles
  has_many :notifications
end
```

**Notification Model:**
```ruby
# Existing Forem model - no changes
class Notification < ApplicationRecord
  # - notifiable_type: string
  # - notifiable_id: bigint
  # - user_id: bigint
  # - action: string (e.g., "comment", "reaction")
  # - notified_at: datetime

  belongs_to :user
  belongs_to :notifiable, polymorphic: true
end
```

**Seed Data Structure:**

```ruby
# db/seeds/vibecoding_content.rb
VIBECODING_TAGS = [
  { name: "vibecoding", short_summary: "General vibecoding content and discussion", supported: true },
  { name: "anyon", short_summary: "ANYON platform features and showcases", supported: true },
  { name: "project-showcase", short_summary: "Showcase your vibecoding projects", supported: true },
  # ... 7 more tags
]

VIBECODING_TEMPLATES = [
  { title: "Project Showcase", body_markdown: "...", article_template_type: "article" },
  { title: "Tutorial", body_markdown: "...", article_template_type: "article" },
  # ... 3 more templates
]

VIBECODING_SEED_POSTS = [
  { title: "...", body_markdown: "...", tags: ["vibecoding", "anyon"], user_id: 1 },
  # ... 19+ more posts
]
```

### APIs and Interfaces

**Forem Admin Panel APIs (Used for Configuration):**

All configuration done via Forem Admin Panel - no custom API endpoints required for this epic.

**Admin Panel Interfaces:**

1. **Tag Management** (`/admin/content_manager/tags`)
   - Create new tags
   - Edit tag descriptions and colors
   - Set featured/supported tags
   - Configure tag moderation rules

2. **Article Templates** (`/admin/customization/config`)
   - Create/edit article templates
   - Manage template visibility
   - Set default templates

3. **Community Settings** (`/admin/customization/config`)
   - Rate limiting configuration
   - Spam detection sensitivity
   - Email notification defaults

4. **Pages Management** (`/admin/pages`)
   - Create/edit static pages
   - Markdown editor for guidelines

**Email Template Interfaces:**

```erb
<!-- app/views/devise/mailer/notification_email.html.erb -->
<!DOCTYPE html>
<html>
<head>
  <style>
    /* Vibecoding branding CSS */
    .vibecoding-header { background: #BRAND_COLOR; }
  </style>
</head>
<body>
  <div class="vibecoding-header">
    <img src="<%= asset_url('vibecoding/logo.png') %>" alt="Vibecoding Community">
  </div>
  <!-- Email content -->
</body>
</html>
```

### Workflows and Sequencing

**Story 4.1: Tag Taxonomy Configuration**

```
1. Content Strategist accesses Admin Panel > Tags
2. For each of 10 core tags:
   a. Create tag with name, short_summary, rules_html
   b. Set bg_color_hex and text_color_hex for visual distinction
   c. Mark primary tags (vibecoding, anyon, project-showcase) as supported
   d. Add SEO-friendly description
3. Test tag display on homepage and post pages
4. Verify tag following functionality
```

**Story 4.2: Content Templates Creation**

```
1. Content Strategist accesses Admin Panel > Article Templates
2. For each of 5 templates:
   a. Create template with title and body_markdown structure
   b. Include inline help text and placeholders
   c. Set default tags for template type
   d. Preview template in post editor
3. Test template selection in post editor
4. Verify template content populates correctly
```

**Story 4.3: Initial Content Seeding**

```
1. Developer creates db/seeds/vibecoding_content.rb
2. Define 20+ seed posts with:
   - 5+ ANYON project showcases (using Project Showcase template)
   - 5+ vibecoding tutorials (using Tutorial template)
   - 3+ ANYON vs Lovable comparisons (using Comparison template)
   - 3+ advanced techniques
   - 4+ community posts
3. Run: rails db:seed:vibecoding_content
4. Verify all posts published and tagged correctly
5. Schedule posts over 2-3 weeks (stagger publication dates)
```

**Story 4.4: Content Moderation Setup**

```
1. Community Manager accesses Admin Panel > Config > Community
2. Configure rate limiting:
   - New users: max 5 posts/day
   - New users: max 3 links per post
3. Enable CAPTCHA on signup
4. Configure spam keyword filters
5. Set up moderation queue for flagged content
6. Document moderation guidelines
7. Test flag/report functionality
```

**Story 4.5: Email Notifications Configuration**

```
1. Developer customizes email templates in app/views/devise/mailer/
2. Add vibecoding branding (logo, colors, footer)
3. Configure via Admin Panel > Config > Emails:
   - Weekly digest enabled
   - Reply notifications enabled
   - Reaction notifications enabled
4. Set up SendGrid environment variables
5. Test email delivery for all notification types
6. Verify unsubscribe functionality
7. Check SPF/DKIM/DMARC configuration
```

## Non-Functional Requirements

### Performance

**Content Loading:**
- Tag pages load in < 500ms (p95) - leverage Forem's existing indexing on articles.tags
- Article templates populate in post editor in < 200ms
- Seed data import completes in < 5 minutes for 20 posts
- Email notifications sent within 5 minutes of triggering event (Sidekiq queue)

**Email Performance:**
- Digest emails generated and queued in < 10 seconds per user
- Email delivery via SendGrid in < 1 minute from queue
- Bounce and complaint processing in real-time
- Email open/click tracking with < 100ms overhead

**Moderation Performance:**
- Rate limiting checks in < 50ms (Redis-backed)
- Spam detection runs inline during post creation with < 200ms overhead
- Moderation queue loads in < 1 second
- Flag/report actions processed in < 500ms

**Optimization Strategies:**
- Leverage Forem's existing database indexes on tags, articles, users
- Cache tag counts and featured tags (Rails fragment caching)
- Use Sidekiq for async email delivery (don't block user requests)
- Batch digest email generation during off-peak hours

**Monitoring:**
- Track email delivery rates via SendGrid dashboard
- Monitor Sidekiq queue depth for notification backlog
- Alert on email bounce rate > 5%
- Track seed data import time in CI/CD

### Security

**Content Security:**
- **XSS Prevention:** All user-generated content sanitized via Forem's HTML pipeline (using Sanitize gem)
- **Spam Prevention:**
  - Rate limiting: 5 posts/day for users < 7 days old (Redis-backed)
  - Link limits: Max 3 links per post for new users
  - CAPTCHA on signup (reCAPTCHA v3)
  - Keyword-based spam filtering
- **Content Moderation:**
  - Flag/report functionality with admin review
  - Auto-unpublish posts with > 5 spam reports pending review
  - IP-based blocking for repeat offenders

**Email Security:**
- **SPF/DKIM/DMARC:** Properly configured for SendGrid to prevent spoofing
- **Unsubscribe Compliance:** CAN-SPAM compliant unsubscribe links in all emails
- **Link Safety:** All email links sanitized, no user-controlled URLs in emails
- **Privacy:** Email addresses never exposed in public pages or headers

**Template Security:**
- Templates stored server-side only (not user-modifiable)
- No executable code in templates (markdown only)
- Template rendering sanitized through Forem's markdown pipeline

**Data Privacy:**
- User email preferences encrypted at rest (Forem default)
- Email notification logs purged after 90 days
- GDPR compliance: Include notification preferences in user data export

**Authentication & Authorization:**
- Only admins can create/edit tags and templates (Pundit policies)
- Only post authors can edit their posts
- Moderation actions logged with admin user ID and timestamp

### Reliability/Availability

**Email Reliability:**
- **Delivery SLA:** 99% delivery rate for transactional emails
- **Retry Logic:** Failed emails retry 3x with exponential backoff via Sidekiq
- **Fallback:** If SendGrid fails, queue emails for retry (don't lose notifications)
- **Monitoring:** Alert on email delivery failure rate > 1%

**Content Availability:**
- Seed data idempotent - can re-run `db:seed:vibecoding_content` without duplicates
- Tag configuration backed up in version control (export to YAML)
- Templates backed up in version control (export markdown)

**Moderation Availability:**
- Rate limiting backed by Redis - if Redis fails, gracefully degrade (log warning, allow post)
- Moderation queue accessible even during high traffic
- Flag/report data persisted in PostgreSQL (survives Redis failures)

**Graceful Degradation:**
- If email service fails, notification preferences still work (emails queued for retry)
- If spam detection slow, timeout after 500ms and allow post through (log for manual review)
- If template loading fails, fall back to empty editor (user can still write)

**Backup & Recovery:**
- Seed posts included in database backups (standard backup strategy)
- Tag configuration can be re-imported from YAML export
- Templates can be re-created from version-controlled markdown

### Observability

**Logging:**

```ruby
# Content creation logging
Rails.logger.info("VIBECODING: Seed post created",
  post_id: article.id,
  title: article.title,
  tags: article.tags
)

# Moderation logging
Rails.logger.warn("VIBECODING: Rate limit triggered",
  user_id: user.id,
  action: "post_create",
  limit: "5/day"
)

# Email logging
Rails.logger.info("VIBECODING: Digest email sent",
  user_id: user.id,
  posts_count: posts.count,
  delivered_at: Time.current
)
```

**Metrics to Track:**

**Content Metrics:**
- Tag creation count and usage over time
- Template selection frequency (which templates most popular)
- Seed post view counts and engagement (reactions, comments)
- Posts created per day (by new users vs established)

**Moderation Metrics:**
- Rate limit triggers per day
- Spam reports filed per day
- Posts auto-unpublished due to spam
- Average moderation response time

**Email Metrics:**
- Email delivery rate (sent vs delivered)
- Bounce rate by email type (digest, notification)
- Open rate by email type
- Click-through rate on email links
- Unsubscribe rate by email type

**Dashboard Requirements:**
- Admin dashboard showing tag usage statistics
- Content performance dashboard showing seed post engagement
- Email deliverability dashboard (SendGrid integration)
- Moderation queue dashboard with pending items count

**Alerting:**
- Alert when email bounce rate > 5%
- Alert when spam reports > 10/day
- Alert when rate limiting triggers > 100/hour (possible attack)
- Alert when Sidekiq notification queue depth > 1000 jobs

**Tools:**
- Rails logger with structured logging (JSON format)
- SendGrid email analytics dashboard
- Forem's built-in admin analytics
- Optional: Sentry for error tracking (if enabled in Epic 6)

## Dependencies and Integrations

### External Service Dependencies

**SendGrid (Email Delivery):**
- **Version:** API v3
- **Purpose:** Transactional emails and digest notifications
- **Plan:** Free tier (100 emails/day initially, upgrade to Essentials $19.95/mo for 50k/month at scale)
- **Integration:** Rails ActionMailer with SendGrid SMTP configuration
- **Configuration:**
  ```ruby
  # config/environments/production.rb
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD']
  }
  ```
- **Features Used:**
  - Email delivery with retry logic
  - SPF/DKIM/DMARC configuration
  - Bounce and complaint handling
  - Email analytics (opens, clicks)
  - Unsubscribe management

**Cloudinary (Image Hosting):**
- **Version:** SDK v1.23
- **Purpose:** Host user-uploaded images and seed post cover images
- **Plan:** Free tier (25 credits/month, 25GB storage)
- **Integration:** Already configured in Forem via CarrierWave
- **Usage:** Cover images for seed posts, user avatars

**Forem Platform (Core Dependency):**
- **Version:** Current stable (Ruby 3.3.0, Rails 7.0.8.4)
- **Critical Dependencies from Forem:**
  - `acts-as-taggable-on ~> 10.0` - Tagging system
  - `devise ~> 4.8` - Authentication
  - `pundit ~> 2.3` - Authorization
  - `sidekiq ~> 6.5.3` - Background jobs for email delivery
  - `redis ~> 4.7.1` - Rate limiting and caching
  - `pg ~> 1.5` - PostgreSQL database

### Backend Dependencies (Ruby Gems)

**Content & Moderation:**
- `acts-as-taggable-on ~> 10.0` - Tag management (existing)
- `sanitize ~> 6.0` - HTML/XSS sanitization (existing)
- `rack-attack ~> 6.6` - Rate limiting (existing, configure for Epic 4)
- `recaptcha ~> 5.12` - CAPTCHA for spam prevention

**Email & Notifications:**
- `devise ~> 4.8` - Email delivery framework (existing)
- `ahoy_email ~> 2.2.0` - Email analytics tracking (existing)
- `premailer-rails ~> 1.11` - Inline CSS for email templates

**Seeds & Data:**
- `faker ~> 3.2` - Generate realistic seed data
- `factory_bot_rails ~> 6.2` - Testing factories (also useful for seeds)

### Frontend Dependencies (JavaScript/Node)

**Content Editor:**
- `preact ~> 10.20.2` - UI framework (existing)
- `@github/markdown-toolbar-element ~> 2.2.0` - Markdown editor toolbar (existing)

**Analytics:**
- Google Tag Manager (CDN - no npm package)
- Google Analytics 4 (CDN - no npm package)

### Database Dependencies

**Schema Extensions (None Required):**
- Epic 4 uses existing Forem tables only
- No custom tables or schema migrations needed

**Indexes Used:**
- `articles.tags` (existing index)
- `users.email` (existing index)
- `notifications.user_id` (existing index)

### Integration Points

**Tag System Integration:**
- **Forem API:** Uses existing Tag model and tagging associations
- **Admin Panel:** Configuration via `/admin/content_manager/tags`
- **Public API:** Tag pages at `/tags/{tag-name}`

**Email Notification Integration:**
- **Forem Notification System:** Existing notification model and delivery
- **SendGrid:** SMTP delivery with webhook callbacks for bounces/complaints
- **User Preferences:** Existing notification preference UI

**Content Moderation Integration:**
- **Forem Moderation:** Existing flag/report system
- **Rate Limiting:** Redis-backed via rack-attack gem
- **Admin Panel:** Moderation queue at `/admin/moderation`

**Seed Data Integration:**
- **Rails Seeds:** `db/seeds/vibecoding_content.rb` loaded via `rails db:seed`
- **Idempotent:** Check for existing data before creating (prevent duplicates)

### Configuration Dependencies

**Environment Variables Required:**

```bash
# SendGrid Configuration
SENDGRID_USERNAME=apikey
SENDGRID_PASSWORD=<api-key>

# Cloudinary Configuration (existing)
CLOUDINARY_URL=cloudinary://<api-key>:<api-secret>@<cloud-name>

# reCAPTCHA Configuration
RECAPTCHA_SITE_KEY=<site-key>
RECAPTCHA_SECRET_KEY=<secret-key>

# Redis Configuration (existing)
REDIS_URL=redis://localhost:6379/0

# Rate Limiting Configuration
RATE_LIMIT_POSTS_PER_DAY=5
RATE_LIMIT_LINKS_PER_POST=3
```

**Admin Panel Configuration:**
- Tag colors and descriptions
- Article template markdown
- Rate limiting thresholds
- Email notification defaults
- Community guidelines text

### Third-Party Service Constraints

**SendGrid Limits:**
- Free tier: 100 emails/day
- Must upgrade at ~50 users with weekly digests
- Bounce rate must stay < 5% or account flagged

**Cloudinary Limits:**
- Free tier: 25 credits/month (sufficient for seed posts)
- Image transformations included
- No bandwidth limits on free tier

**Redis Limits:**
- Managed Redis via Railway/Render
- Starter tier sufficient for rate limiting
- 256MB RAM minimum recommended

### Version Constraints

**Ruby Version:**
- Ruby 3.3.0 (Forem requirement)
- Managed via `.ruby-version` file

**Rails Version:**
- Rails 7.0.8.4 (Forem current version)
- No upgrade required for Epic 4

**Node.js Version:**
- Node 20.x (Forem requirement)
- For asset compilation only

**PostgreSQL Version:**
- PostgreSQL 14+ recommended
- 16+ supported

### Migration Path

**From Epic 3 (SEO) to Epic 4:**
- No breaking changes
- Add SendGrid configuration
- Configure reCAPTCHA keys
- Import seed data

**From Epic 4 to Epic 5 (Analytics):**
- Email analytics already tracked via ahoy_email
- GA4 integration builds on existing tracking
- No conflicts

## Acceptance Criteria (Authoritative)

### Story 4.1: Tag Taxonomy & Content Organization

**AC-4.1.1: Core Tags Created**
- GIVEN the platform supports tagging
- WHEN I access the tag management system
- THEN the following 10 tags are configured:
  - `#vibecoding` - General vibecoding content and discussion (supported/featured)
  - `#anyon` - ANYON platform features and showcases (supported/featured)
  - `#project-showcase` - Showcase your vibecoding projects (supported/featured)
  - `#tutorial` - How-to guides and tutorials
  - `#ai-development` - AI-assisted development practices
  - `#prompting` - Prompting patterns and techniques
  - `#maintenance` - Ongoing project maintenance
  - `#lovable-alternative` - Comparisons with alternatives
  - `#beginner` - Content for newcomers
  - `#advanced` - Advanced techniques

**AC-4.1.2: Tag Configuration Complete**
- GIVEN tags are created
- WHEN I view each tag
- THEN each tag includes:
  - `short_summary` field populated with description
  - `rules_html` field with usage guidelines
  - `bg_color_hex` and `text_color_hex` for visual distinction
  - Primary tags (`vibecoding`, `anyon`, `project-showcase`) marked as `supported: true`

**AC-4.1.3: Tag Pages SEO Optimized**
- GIVEN tags are configured
- WHEN I visit `/tags/{tag-name}`
- THEN the tag page includes:
  - SEO-friendly meta description
  - Tag description visible to users
  - All posts tagged with this tag displayed
  - Tag following functionality operational

### Story 4.2: Content Templates for Common Post Types

**AC-4.2.1: Five Templates Created**
- GIVEN the article template system
- WHEN I access article templates
- THEN the following 5 templates exist:
  1. **Project Showcase** - Problem, Why ANYON, The Build, Tech Stack, Results, Lessons Learned
  2. **Tutorial** - Introduction, Prerequisites, Steps, Code Examples, Conclusion
  3. **Comparison** - Overview, Feature Matrix, Pros/Cons, Recommendation
  4. **Technique** - Problem, Solution, Code Example, When to Use
  5. **Weekly Roundup** - Top Posts, Community Highlights, Featured Projects

**AC-4.2.2: Templates Include Guidance**
- GIVEN templates are created
- WHEN I select a template in the post editor
- THEN the template includes:
  - Structured sections with markdown headings
  - Placeholder text showing what to include
  - Inline help text and examples
  - Auto-suggested tags appropriate for template type
  - SEO-friendly structure

**AC-4.2.3: Template Selection Functional**
- GIVEN I am creating a new post
- WHEN I access the post editor
- THEN I can:
  - See a template selector/dropdown
  - Select any of the 5 templates
  - See the template content populate the editor
  - Preview the template structure before writing

### Story 4.3: Initial Content Seeding (20+ Posts)

**AC-4.3.1: Minimum 20 Posts Published**
- GIVEN the seed data script
- WHEN I run `rails db:seed:vibecoding_content`
- THEN at least 20 posts are created covering:
  - 5+ ANYON project showcases (using Project Showcase template)
  - 5+ vibecoding tutorials (using Tutorial template)
  - 3+ ANYON vs Lovable comparisons (using Comparison template)
  - 3+ advanced vibecoding techniques
  - 4+ community-building posts (welcome, guidelines, tips)

**AC-4.3.2: Seed Content Quality Standards**
- GIVEN seed posts are created
- WHEN I review each post
- THEN each post meets quality standards:
  - Uses appropriate template structure
  - Has a cover image (via Cloudinary)
  - Is SEO-optimized (keywords in title and content)
  - Includes code examples or screenshots where appropriate
  - Demonstrates vibecoding value proposition
  - Tagged with relevant tags

**AC-4.3.3: Content Distribution Scheduled**
- GIVEN seed posts are created
- WHEN I check publication dates
- THEN posts are:
  - Scheduled over 2-3 weeks (not all published at once)
  - Attributed to variety of team member accounts
  - Mix of beginner and advanced topics
  - Cross-linked for internal SEO

**AC-4.3.4: Seed Data Idempotent**
- GIVEN seed script has run once
- WHEN I run `rails db:seed:vibecoding_content` again
- THEN no duplicate posts are created (check by title or slug)

### Story 4.4: Content Moderation & Spam Prevention

**AC-4.4.1: Rate Limiting Configured**
- GIVEN the platform accepts user posts
- WHEN a new user (< 7 days old) attempts to post
- THEN rate limiting enforces:
  - Maximum 5 posts per day for new users
  - Maximum 3 links per post for new users
  - Rate limits tracked via Redis
  - Exceeded limits show clear error message

**AC-4.4.2: CAPTCHA on Signup**
- GIVEN the signup flow
- WHEN a user attempts to register
- THEN reCAPTCHA v3 is:
  - Enabled on signup form
  - Validated server-side
  - Prevents bot account creation

**AC-4.4.3: Spam Detection Active**
- GIVEN spam keyword filters are configured
- WHEN a post contains spam indicators
- THEN the post is:
  - Flagged for moderation review
  - Not immediately published (if trigger threshold met)
  - Logged for admin visibility

**AC-4.4.4: Moderation Workflow Operational**
- GIVEN content moderation tools are configured
- WHEN I access `/admin/moderation`
- THEN I can:
  - View flagged content in moderation queue
  - Unpublish, edit, or delete posts
  - Suspend or ban user accounts
  - View moderation activity log
  - See all flag/report reasons

**AC-4.4.5: Flag/Report Functionality**
- GIVEN I am viewing a post or comment
- WHEN I click the flag/report button
- THEN I can:
  - Select a report reason (spam, harassment, off-topic, etc.)
  - Submit the report
  - See confirmation that report was filed
  - Know that admins are notified

### Story 4.5: Email Notifications & Engagement

**AC-4.5.1: Email Preferences Configurable**
- GIVEN I am a registered user
- WHEN I access my notification settings
- THEN I can configure:
  - Weekly digest of top posts (on/off)
  - Notifications for replies to my comments (on/off)
  - Notifications for reactions to my posts (on/off)
  - New posts from followed tags (on/off)
  - New posts from followed users (on/off)

**AC-4.5.2: Branded Email Templates**
- GIVEN email notifications are configured
- WHEN I receive an email notification
- THEN the email includes:
  - Vibecoding Community logo and branding
  - Branded header with brand colors
  - Clear, readable content preview
  - CTA link back to platform (with UTM tracking)
  - Unsubscribe link (CAN-SPAM compliant)
  - Vibecoding footer with social links

**AC-4.5.3: Email Delivery Functional**
- GIVEN SendGrid is configured
- WHEN a notification event occurs
- THEN the email is:
  - Queued via Sidekiq within 5 seconds
  - Sent via SendGrid within 5 minutes
  - Delivered to user's inbox
  - Tracked for opens and clicks (via ahoy_email)

**AC-4.5.4: Email Deliverability Configured**
- GIVEN production email setup
- WHEN I check DNS and email configuration
- THEN the following are verified:
  - SPF record configured for SendGrid
  - DKIM record configured for SendGrid
  - DMARC record configured (policy: quarantine or reject)
  - SendGrid domain authentication verified
  - Bounce and complaint webhooks configured

**AC-4.5.5: Unsubscribe Functional**
- GIVEN I receive an email notification
- WHEN I click the unsubscribe link
- THEN I am:
  - Taken to unsubscribe preference page
  - Able to unsubscribe from specific email types or all emails
  - See confirmation that preferences are saved
  - No longer receive emails of that type

## Traceability Mapping

| Acceptance Criteria | PRD Section | Epic/Story | Component | Test Type |
|---------------------|-------------|------------|-----------|-----------|
| **AC-4.1.1** Core Tags Created | FR 2.2 Tagging & Categorization | Epic 4, Story 4.1 | Forem Tag Model, Admin Panel | Manual (Admin UI) |
| **AC-4.1.2** Tag Configuration Complete | FR 2.2 Tagging & Categorization | Epic 4, Story 4.1 | Tag Model Fields | Manual (Admin UI) |
| **AC-4.1.3** Tag Pages SEO Optimized | FR 5.1 SEO Optimization | Epic 4, Story 4.1 | Tag Pages, Meta Tags | Integration Test |
| **AC-4.2.1** Five Templates Created | FR 7.2 Content Templates | Epic 4, Story 4.2 | Article Templates | Manual (Admin UI) |
| **AC-4.2.2** Templates Include Guidance | FR 7.2 Content Templates | Epic 4, Story 4.2 | Template Markdown | Manual Review |
| **AC-4.2.3** Template Selection Functional | FR 2.1 Post Creation | Epic 4, Story 4.2 | Post Editor UI | E2E Test (Cypress) |
| **AC-4.3.1** Minimum 20 Posts Published | FR 7.1 Initial Content Creation | Epic 4, Story 4.3 | `db/seeds/vibecoding_content.rb` | Automated (RSpec) |
| **AC-4.3.2** Seed Content Quality Standards | FR 7.1 Initial Content Creation | Epic 4, Story 4.3 | Seed Post Data | Manual Review |
| **AC-4.3.3** Content Distribution Scheduled | FR 7.1 Initial Content Creation | Epic 4, Story 4.3 | Seed Script Logic | Automated (RSpec) |
| **AC-4.3.4** Seed Data Idempotent | FR 7.1 Initial Content Creation | Epic 4, Story 4.3 | Seed Script Logic | Automated (RSpec) |
| **AC-4.4.1** Rate Limiting Configured | FR 8.2 Spam Prevention | Epic 4, Story 4.4 | Rack::Attack Config, Redis | Integration Test |
| **AC-4.4.2** CAPTCHA on Signup | FR 8.2 Spam Prevention | Epic 4, Story 4.4 | Devise + reCAPTCHA | E2E Test (Cypress) |
| **AC-4.4.3** Spam Detection Active | FR 8.2 Spam Prevention | Epic 4, Story 4.4 | Moderation System | Integration Test |
| **AC-4.4.4** Moderation Workflow Operational | FR 2.4 Post Moderation | Epic 4, Story 4.4 | Admin Moderation UI | Manual (Admin UI) |
| **AC-4.4.5** Flag/Report Functionality | FR 2.4 Post Moderation | Epic 4, Story 4.4 | Report System | E2E Test (Cypress) |
| **AC-4.5.1** Email Preferences Configurable | NFR Privacy | Epic 4, Story 4.5 | User Settings UI | E2E Test (Cypress) |
| **AC-4.5.2** Branded Email Templates | UX Principles | Epic 4, Story 4.5 | Email Views (ERB) | Manual Review |
| **AC-4.5.3** Email Delivery Functional | FR 8.1 Email Notifications | Epic 4, Story 4.5 | ActionMailer, Sidekiq, SendGrid | Integration Test |
| **AC-4.5.4** Email Deliverability Configured | NFR Security | Epic 4, Story 4.5 | DNS, SendGrid Config | Manual Verification |
| **AC-4.5.5** Unsubscribe Functional | NFR Security (Privacy) | Epic 4, Story 4.5 | Unsubscribe Logic | E2E Test (Cypress) |

## Risks, Assumptions, Open Questions

### Risks

**RISK-4.1: SendGrid Free Tier Exhaustion**
- **Severity:** Medium
- **Probability:** High
- **Description:** Free tier limited to 100 emails/day. With weekly digests enabled for 50+ users, will quickly exceed limit.
- **Impact:** Email notifications stop working, degraded user experience
- **Mitigation:**
  - Monitor SendGrid usage daily during first 2 weeks
  - Upgrade to Essentials plan ($19.95/mo for 50k emails) before hitting limit
  - Consider batching digest emails to reduce volume initially
  - Alert trigger at 80% of daily quota

**RISK-4.2: Seed Content Quality Below Expectations**
- **Severity:** Medium
- **Probability:** Medium
- **Description:** Team-authored seed posts may not demonstrate sufficient quality or vibecoding value
- **Impact:** Early users don't see value, low engagement, poor first impression
- **Mitigation:**
  - Conduct content review with 2+ team members before seeding
  - Include 3-5 high-quality ANYON project showcases with real screenshots
  - Use professional cover images from Unsplash or similar
  - Run content past external beta testers for feedback

**RISK-4.3: Spam Detection Too Aggressive**
- **Severity:** Low
- **Probability:** Medium
- **Description:** Spam filters may flag legitimate posts, frustrating real users
- **Impact:** False positives, user complaints, manual moderation burden
- **Mitigation:**
  - Start with conservative spam detection thresholds
  - Manual review queue for flagged posts (don't auto-reject)
  - Monitor false positive rate first 30 days
  - Iterate spam keyword filters based on real data

**RISK-4.4: Email Deliverability Issues**
- **Severity:** High
- **Probability:** Low
- **Description:** SPF/DKIM/DMARC misconfiguration or SendGrid domain reputation issues
- **Impact:** Emails land in spam, low engagement, compliance issues
- **Mitigation:**
  - Verify SPF/DKIM/DMARC configuration with SendGrid tools before launch
  - Use SendGrid domain authentication (not shared IP)
  - Monitor bounce rate and spam complaint rate daily
  - Warm up email sending gradually (don't send 1000 emails day 1)

**RISK-4.5: Tag Taxonomy Doesn't Resonate**
- **Severity:** Low
- **Probability:** Medium
- **Description:** Chosen tags may not match how users naturally categorize vibecoding content
- **Impact:** Low tag usage, hard to discover content, poor organization
- **Mitigation:**
  - Monitor tag usage first 2 weeks
  - Iterate based on user behavior (add popular tags, remove unused)
  - Gather feedback from early community members
  - Allow users to suggest new tags via feedback form

### Assumptions

**ASSUMPTION-4.1: Forem Tag System Sufficient**
- **Assumption:** Forem's built-in tagging system (acts-as-taggable-on) is sufficient for vibecoding taxonomy
- **Validation:** Review Forem tag features against PRD requirements
- **If False:** May need custom tag extensions or categories

**ASSUMPTION-4.2: 20 Seed Posts Adequate**
- **Assumption:** 20+ high-quality seed posts provide sufficient content to demonstrate value to early users
- **Validation:** Monitor bounce rate and time-on-site for first 100 users
- **If False:** Create additional seed content before broader launch

**ASSUMPTION-4.3: Weekly Digest Sufficient Engagement**
- **Assumption:** Weekly email digests are sufficient to keep users engaged (no need for daily)
- **Validation:** Monitor email open rates and return user rates
- **If False:** Add daily digest option or other notification frequencies

**ASSUMPTION-4.4: Team Can Author Quality Content**
- **Assumption:** Team members have capacity and skill to write 20+ high-quality vibecoding posts
- **Validation:** Review first 3-5 posts for quality
- **If False:** Hire freelance technical writers or leverage ANYON users for content

**ASSUMPTION-4.5: reCAPTCHA v3 Prevents Bot Signups**
- **Assumption:** reCAPTCHA v3 (invisible) is sufficient to prevent bot account creation
- **Validation:** Monitor signup patterns for bot-like behavior
- **If False:** Upgrade to reCAPTCHA v2 (checkbox) or add additional verification

**ASSUMPTION-4.6: Rate Limits Don't Frustrate Legitimate Users**
- **Assumption:** 5 posts/day limit for new users is reasonable and won't frustrate legitimate vibecoding enthusiasts
- **Validation:** Monitor support requests and user feedback
- **If False:** Adjust rate limits or reduce new user period from 7 days

### Open Questions

**QUESTION-4.1: Content Moderation Staffing**
- **Question:** Who will handle day-to-day content moderation and how much time will it require?
- **Answer Needed By:** Before launch (Story 4.4 completion)
- **Blocking:** Story 4.4 implementation
- **Proposed Solution:** Assign primary moderator (JSup?) with backup, estimate 30-60 min/day initially

**QUESTION-4.2: Digest Email Send Time**
- **Question:** What day/time should weekly digest emails be sent for optimal engagement?
- **Answer Needed By:** Story 4.5 implementation
- **Blocking:** Email scheduling configuration
- **Proposed Solution:** A/B test Monday morning vs. Friday afternoon, measure open rates

**QUESTION-4.3: Seed Post Attribution**
- **Question:** Should seed posts be attributed to real team member accounts or generic "Vibecoding Team" account?
- **Answer Needed By:** Before Story 4.3 execution
- **Blocking:** Seed data script development
- **Proposed Solution:** Use real team accounts for authenticity, create 3-5 team accounts

**QUESTION-4.4: Template Enforcement**
- **Question:** Should templates be mandatory for certain post types (e.g., project showcases must use template) or optional?
- **Answer Needed By:** Story 4.2 implementation
- **Blocking:** Template configuration
- **Proposed Solution:** Start optional, encourage via UI prompts, don't enforce

**QUESTION-4.5: Tag Limit Per Post**
- **Question:** What's the maximum number of tags allowed per post (Forem default is 4, should we increase to 5)?
- **Answer Needed By:** Story 4.1 configuration
- **Blocking:** Tag system configuration
- **Proposed Solution:** Keep Forem default (4 tags) for MVP, increase if users request

**QUESTION-4.6: Email Notification Defaults**
- **Question:** Should new users be opted-in or opted-out of email notifications by default?
- **Answer Needed By:** Story 4.5 configuration
- **Blocking:** User registration flow
- **Proposed Solution:** Opt-in to weekly digest by default, opt-out of everything else (user can enable)

## Test Strategy Summary

### Test Levels

**1. Unit Tests (RSpec)**

**Scope:** Individual components and services
**Coverage Target:** 80% for custom code (seed scripts, custom concerns)
**Tools:** RSpec, FactoryBot

**Test Cases:**
- Seed data script creates correct number of posts (AC-4.3.1)
- Seed data script is idempotent (AC-4.3.4)
- Rate limiting logic correctly identifies new users (AC-4.4.1)
- Email notification queuing logic (AC-4.5.3)

**Example:**
```ruby
# spec/db/seeds/vibecoding_content_spec.rb
RSpec.describe 'Vibecoding Content Seeds' do
  it 'creates exactly 20 posts' do
    load Rails.root.join('db/seeds/vibecoding_content.rb')
    expect(Article.count).to eq(20)
  end

  it 'is idempotent' do
    2.times { load Rails.root.join('db/seeds/vibecoding_content.rb') }
    expect(Article.count).to eq(20) # Not 40
  end
end
```

**2. Integration Tests (RSpec + Request Specs)**

**Scope:** Component interactions, API endpoints, database
**Coverage Target:** All critical paths
**Tools:** RSpec, rack-test

**Test Cases:**
- Tag pages render correctly with SEO meta tags (AC-4.1.3)
- Rate limiting blocks excessive posts (AC-4.4.1)
- Spam detection flags posts correctly (AC-4.4.3)
- Email delivery via SendGrid (AC-4.5.3)

**Example:**
```ruby
# spec/requests/rate_limiting_spec.rb
RSpec.describe 'Rate Limiting' do
  let(:new_user) { create(:user, created_at: 2.days.ago) }

  it 'blocks 6th post from new user' do
    5.times { create(:article, user: new_user) }

    post '/articles', params: { article: attributes_for(:article) }, headers: auth_headers(new_user)

    expect(response).to have_http_status(:too_many_requests)
    expect(response.body).to include('Rate limit exceeded')
  end
end
```

**3. End-to-End Tests (Cypress)**

**Scope:** User workflows from browser perspective
**Coverage Target:** All critical user journeys
**Tools:** Cypress

**Test Cases:**
- User selects template and creates post (AC-4.2.3)
- User flags post for moderation (AC-4.4.5)
- User configures email preferences (AC-4.5.1)
- User unsubscribes from emails (AC-4.5.5)
- CAPTCHA appears on signup (AC-4.4.2)

**Example:**
```javascript
// cypress/e2e/content_templates.cy.js
describe('Content Templates', () => {
  it('allows user to select and use project showcase template', () => {
    cy.login()
    cy.visit('/new')

    cy.get('[data-template-selector]').click()
    cy.get('[data-template="project-showcase"]').click()

    cy.get('[data-editor]').should('contain', '## Problem')
    cy.get('[data-editor]').should('contain', '## Why ANYON')
  })
})
```

**4. Manual Testing**

**Scope:** Admin UI, visual design, content quality
**Tools:** Manual browser testing, checklist

**Test Cases:**
- Tag configuration via Admin Panel (AC-4.1.1, AC-4.1.2)
- Template creation via Admin Panel (AC-4.2.1, AC-4.2.2)
- Moderation queue workflow (AC-4.4.4)
- Email template branding visual review (AC-4.5.2)
- Seed content quality review (AC-4.3.2)

**Manual Test Checklist:**
- [ ] All 10 tags configured with descriptions
- [ ] All 5 templates created and usable
- [ ] All 20+ seed posts published and high quality
- [ ] Moderation queue accessible and functional
- [ ] Email templates branded correctly
- [ ] SPF/DKIM/DMARC verified via SendGrid

**5. External Service Testing**

**Scope:** Third-party integrations (SendGrid, reCAPTCHA, Cloudinary)
**Tools:** Service-specific test tools

**Test Cases:**
- SendGrid email delivery (AC-4.5.3)
- SPF/DKIM/DMARC configuration (AC-4.5.4)
- reCAPTCHA validation (AC-4.4.2)
- Cloudinary image uploads for seed posts (AC-4.3.2)

**Verification Steps:**
1. Send test email via SendGrid, verify delivery
2. Use MXToolbox to verify SPF/DKIM/DMARC records
3. Test signup with reCAPTCHA in staging environment
4. Upload test image to Cloudinary, verify URL generation

### Test Data Strategy

**Seed Data for Testing:**
- Use FactoryBot to generate test users, articles, tags
- Create realistic test data (not "Test Post 1", "Test Post 2")
- Use Faker gem for realistic names, content

**Test Isolation:**
- DatabaseCleaner to reset DB between tests
- Separate Redis database for test environment
- Mock SendGrid in test environment (use mail catcher)

### Coverage Goals

| Test Type | Coverage Target | Priority |
|-----------|-----------------|----------|
| Unit Tests | 80% of custom code | High |
| Integration Tests | All critical paths | High |
| E2E Tests | All user workflows | Medium |
| Manual Tests | 100% of admin features | High |
| External Service Tests | All integrations verified | High |

### Test Execution Strategy

**CI/CD Integration:**
- All RSpec tests run on every PR
- Cypress E2E tests run on merge to main
- Manual tests performed before production deploy

**Test Environments:**
- **Local:** Full test suite during development
- **Staging:** E2E tests + manual tests before production
- **Production:** Smoke tests after deployment

### Edge Cases to Test

1. **Seed data script run multiple times** (idempotency)
2. **User at exactly 7 days old** (rate limit edge case)
3. **Email with special characters in subject** (encoding)
4. **Post with exactly 3 links** (rate limit boundary)
5. **Tag with special characters** (URL encoding)
6. **Very long email digest** (performance)
7. **SendGrid temporarily down** (retry logic)
8. **User unsubscribes then resubscribes** (preference handling)

### Success Criteria for Testing

**Epic 4 is ready to deploy when:**
- [ ] All automated tests passing (RSpec + Cypress)
- [ ] Manual test checklist 100% complete
- [ ] All 20 ACs verified in staging environment
- [ ] External services (SendGrid, reCAPTCHA) verified operational
- [ ] Performance targets met (email < 5min, tag pages < 500ms)
- [ ] Security audit passed (rate limiting, CAPTCHA, email security)
- [ ] Content quality review approved by stakeholders
