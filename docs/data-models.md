# Data Models - Vibecoding Community

## Overview

This document describes the database schema and data models for the Vibecoding Community platform. The application uses PostgreSQL with Active Record ORM.

**Database:** PostgreSQL
**ORM:** ActiveRecord (Rails 7.0.8)
**Total Tables:** 106
**Total Models:** 105+

**PostgreSQL Extensions Enabled:**
- `citext` - Case-insensitive text
- `ltree` - Hierarchical tree structures
- `pg_trgm` - Trigram matching for fuzzy search
- `pgcrypto` - Cryptographic functions
- `plpgsql` - Procedural language
- `unaccent` - Remove accents from text

---

## Core Domain Models

### Content Models

**Articles**
- **Table:** `articles`
- **Model:** `app/models/article.rb`
- **Purpose:** Main content type - blog posts, tutorials, discussions
- **Key Fields:**
  - `body_markdown`, `body_html`
  - `title`, `slug`
  - `user_id`, `organization_id`
  - `published`, `approved`, `archived`
  - `comments_count`, `reactions_count`
  - `cached_tag_list`
- **Relationships:**
  - Belongs to User, Organization
  - Has many Comments, Reactions, Tags

**Comments**
- **Table:** `comments`
- **Model:** `app/models/comment.rb`
- **Purpose:** Nested comment threads on articles
- **Key Features:**
  - Nested comments (uses `ancestry` gem)
  - Markdown support
  - Reactions and voting

**Tags**
- **Table:** Uses `acts-as-taggable-on` gem tables
- **Model:** `app/models/tag.rb`
- **Purpose:** Content categorization and discovery
- **Implementation:** ActsAsTaggableOn gem

**Collections**
- **Table:** `collections`
- **Model:** `app/models/collection.rb`
- **Purpose:** Curated article groups/series

---

### User Models

**Users**
- **Table:** `users`
- **Model:** `app/models/user.rb`
- **Purpose:** Core user accounts
- **Authentication:** Devise gem
- **Key Fields:**
  - Profile: `name`, `username`, `summary`, `website_url`
  - Settings: `email_public`, `config_theme`, `config_font`
  - Gamification: `credits`, `experience_level`
  - Reputation: `reputation_modifier`, `score`
- **Relationships:**
  - Has many Articles, Comments, Reactions
  - Has many Badge Achievements
  - Follower/Following relationships

**Organizations**
- **Table:** `organizations`
- **Model:** `app/models/organization.rb`
- **Purpose:** Company/team accounts
- **Features:** Multi-user organizations with roles

**Profiles**
- **Purpose:** Extended user profile information
- **Fields:** Bio, location, education, work history

---

### Social & Engagement Models

**Reactions**
- **Table:** `reactions`
- **Model:** `app/models/reaction.rb`
- **Purpose:** Emoji reactions on content (❤️, 🦄, 🔥, etc.)
- **Polymorphic:** Can react to Articles, Comments, Users

**Follows**
- **Table:** `follows`
- **Model:** Via `acts_as_follower` gem
- **Purpose:** User following system
- **Types:** Follow users, tags, organizations

**Badge Achievements**
- **Table:** `badge_achievements`
- **Model:** `app/models/badge_achievement.rb`
- **Purpose:** User badges and achievements

**Badges**
- **Table:** `badges`
- **Model:** `app/models/badge.rb`
- **Purpose:** Badge definitions

---

### Platform Features

**Broadcasts**
- **Table:** `broadcasts`
- **Model:** `app/models/broadcast.rb`
- **Purpose:** Platform-wide announcements

**Billboards**
- **Table:** `billboards`
- **Model:** `app/models/billboard.rb`
- **Purpose:** Advertisement/sponsorship system

**Billboard Events**
- **Table:** `billboard_events`
- **Model:** `app/models/billboard_event.rb`
- **Purpose:** Ad impression/click tracking

**Listings**
- **Table:** `listings`
- **Model:** `app/models/listing.rb`
- **Purpose:** Classified ads (jobs, products, events, etc.)

**Campaigns**
- **Table:** `campaigns`
- **Model:** `app/models/campaign.rb`
- **Purpose:** Marketing campaigns

---

### Analytics & Tracking

**Ahoy Events**
- **Table:** `ahoy_events`
- **Model:** Via `ahoy_matey` gem
- **Purpose:** User behavior analytics
- **Fields:** `name`, `properties` (jsonb), `user_id`, `visit_id`

**Ahoy Visits**
- **Table:** `ahoy_visits`
- **Model:** Via `ahoy_matey` gem
- **Purpose:** Visit tracking
- **Fields:** `visit_token`, `visitor_token`, `user_id`

**Ahoy Messages**
- **Table:** `ahoy_messages`
- **Model:** Via `ahoy_email` gem
- **Purpose:** Email analytics
- **Tracks:** Opens, clicks, UTM parameters

**Audit Logs**
- **Table:** `audit_logs`
- **Model:** `app/models/audit_log.rb`
- **Purpose:** Admin action auditing

---

### Configuration & Settings

**Site Config**
- **Table:** `site_configs`
- **Model:** `app/models/site_config.rb`
- **Purpose:** Instance-wide configuration

**Feature Flags**
- **Table:** Via `flipper` gem tables
- **Purpose:** Feature toggles and A/B testing
- **Storage:** `flipper` with ActiveRecord backend

**API Secrets**
- **Table:** `api_secrets`
- **Model:** `app/models/api_secret.rb`
- **Purpose:** User API token management

---

### Content Extensions

**Podcasts**
- **Tables:** `podcasts`, `podcast_episodes`
- **Models:** `app/models/podcast.rb`, `app/models/podcast_episode.rb`
- **Purpose:** Podcast hosting and episodes

**Videos**
- **Table:** `videos`
- **Model:** `app/models/video.rb`
- **Purpose:** Video content

**Pages**
- **Table:** `pages`
- **Model:** `app/models/page.rb`
- **Purpose:** Static/custom pages

---

### Moderation & Safety

**Context Notes**
- **Table:** `context_notes`
- **Model:** `app/models/context_note.rb`
- **Purpose:** Moderation notes on content

**Banished Users**
- **Table:** `banished_users`
- **Model:** `app/models/banished_user.rb`
- **Purpose:** Banned user tracking

**Blocked Email Domains**
- **Table:** `blocked_email_domains`
- **Model:** `app/models/blocked_email_domain.rb`
- **Purpose:** Email domain blocking for spam prevention

---

### Background Jobs

**Sidekiq**
- Background job processing via Sidekiq + Redis
- Scheduled jobs via `sidekiq-cron`
- Unique jobs via `sidekiq-unique-jobs`

**Workers Location:** `app/workers/`

---

### Push Notifications

**Rpush**
- **Tables:** `rpush_notifications`, `rpush_apps`, `rpush_feedback`
- **Gem:** `rpush`
- **Purpose:** Mobile push notifications (iOS/Android)

---

## Database Patterns & Features

### Caching Strategy

**Counter Caches:**
- Uses `counter_culture` gem for efficient counters
- Examples: `comments_count`, `reactions_count` on articles

**Cached Fields:**
- `cached_tag_list` on articles
- `cached_user` (denormalized user data)
- `cached_organization`

### Search & Discovery

**Full-Text Search:**
- `pg_search` gem for PostgreSQL full-text search
- Trigram matching for fuzzy search (`pg_trgm`)

**Tagging System:**
- `acts-as-taggable-on` gem
- Multiple tagging contexts

### Hierarchical Data

**Nested Comments:**
- Uses `ancestry` gem
- ltree extension for efficient tree queries

### Internationalization

**I18n:**
- `i18n-js` for frontend translations
- Translation files managed via `i18n-tasks`

---

## Data Relationships

```
User
├── has_many :articles
├── has_many :comments
├── has_many :reactions
├── has_many :badge_achievements
├── has_many :follows (as follower)
└── has_many :followers (as followable)

Article
├── belongs_to :user
├── belongs_to :organization (optional)
├── has_many :comments
├── has_many :reactions
└── has_many :tags (through taggings)

Comment
├── belongs_to :user
├── belongs_to :commentable (polymorphic - Article, etc.)
├── has_many :reactions
└── has_ancestry (parent/child comments)

Organization
├── has_many :users
├── has_many :articles
└── has_many :organization_memberships
```

---

## Migrations

**Location:** `db/migrate/`
**Schema Version:** `2025_10_22_175824`

**Migration Tools:**
- `strong_migrations` gem - Catch unsafe migrations
- `hairtrigger` gem - Database triggers

---

## Testing Data

**Factories:** `spec/factories/` (using `factory_bot_rails`)
**Fake Data:** `faker` gem for test data generation

---

**Generated:** 2025-11-09 (Deep Scan)
**Scan Mode:** Schema analysis with model discovery
