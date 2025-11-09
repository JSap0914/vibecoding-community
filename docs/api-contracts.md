# API Contracts - Vibecoding Community

## Overview

This document describes the API structure for the Vibecoding Community platform (Forem-based application). The application provides both a web interface and RESTful APIs organized into versioned endpoints.

**API Architecture:**
- **Version 0 (v0)**: Legacy API endpoints
- **Version 1 (v1)**: Current stable API
- **Web Controllers**: Traditional Rails controllers serving HTML views

**Total Controllers:** 76 main controllers + API-specific controllers
**Authentication:** Devise-based authentication with API token support

---

## API Endpoints by Version

### API v0 Endpoints

Located in `app/controllers/api/v0/`

| Endpoint | Controller | Purpose |
|----------|-----------|---------|
| `/api/v0/analytics` | `analytics_controller.rb` | Analytics data and metrics |
| `/api/v0/articles` | `articles_controller.rb` | Article/post management |
| `/api/v0/badge_achievements` | `badge_achievements_controller.rb` | User badge achievements |
| `/api/v0/badges` | `badges_controller.rb` | Badge definitions |
| `/api/v0/comments` | `comments_controller.rb` | Comment operations |
| `/api/v0/feature_flags` | `feature_flags_controller.rb` | Feature flag status |
| `/api/v0/followers` | `followers_controller.rb` | Follower relationships |
| `/api/v0/follows` | `follows_controller.rb` | Follow operations |
| `/api/v0/health_checks` | `health_checks_controller.rb` | Service health monitoring |
| `/api/v0/instances` | `instances_controller.rb` | Instance information |
| `/api/v0/listings` | `listings_controller.rb` | Classified listings |
| `/api/v0/organizations` | `organizations_controller.rb` | Organization management |
| `/api/v0/podcast_episodes` | `podcast_episodes_controller.rb` | Podcast content |
| `/api/v0/profile_images` | `profile_images_controller.rb` | User profile images |
| `/api/v0/readinglist` | `readinglist_controller.rb` | User reading lists |
| `/api/v0/subforems` | `subforems_controller.rb` | Sub-community management |
| `/api/v0/tags` | `tags_controller.rb` | Tag operations |
| `/api/v0/users` | `users_controller.rb` | User profile operations |
| `/api/v0/videos` | `videos_controller.rb` | Video content |

### API v1 Endpoints

Located in `app/controllers/api/v1/`

| Endpoint | Controller | Purpose |
|----------|-----------|---------|
| `/api/v1/analytics` | `analytics_controller.rb` | Enhanced analytics |
| `/api/v1/articles` | `articles_controller.rb` | Article CRUD operations |
| `/api/v1/audience_segments` | `audience_segments_controller.rb` | User segmentation |
| `/api/v1/badge_achievements` | `badge_achievements_controller.rb` | Badge tracking |
| `/api/v1/badges` | `badges_controller.rb` | Badge management |
| `/api/v1/comments` | `comments_controller.rb` | Comment threads |
| `/api/v1/feature_flags` | `feature_flags_controller.rb` | A/B testing flags |
| `/api/v1/feedback_messages` | `feedback_messages_controller.rb` | User feedback |
| `/api/v1/followers` | `followers_controller.rb` | Follower lists |
| `/api/v1/follows` | `follows_controller.rb` | Follow/unfollow |
| `/api/v1/health_checks` | `health_checks_controller.rb` | System health |
| `/api/v1/instances` | `instances_controller.rb` | Multi-tenant info |
| `/api/v1/listings` | `listings_controller.rb` | Listings API |
| `/api/v1/organizations` | `organizations_controller.rb` | Org management |
| `/api/v1/pages` | `pages_controller.rb` | Static pages |
| `/api/v1/podcast_episodes` | `podcast_episodes_controller.rb` | Podcast API |
| `/api/v1/profile_images` | `profile_images_controller.rb` | Image uploads |
| `/api/v1/readinglist` | `readinglist_controller.rb` | Saved articles |
| `/api/v1/recommended_articles_lists` | `recommended_articles_lists_controller.rb` | Content recommendations |
| `/api/v1/subforems` | `subforems_controller.rb` | Sub-communities |
| `/api/v1/tags` | `tags_controller.rb` | Tag system |
| `/api/v1/user_roles` | `user_roles_controller.rb` | Role management |
| `/api/v1/users` | `users_controller.rb` | User API |
| `/api/v1/videos` | `videos_controller.rb` | Video management |

---

## Key Web Controllers

Located in `app/controllers/`

**Core Content:**
- `articles_controller.rb` - Main article/post handling
- `comments_controller.rb` - Comment system
- `tags_controller.rb` - Tag-based navigation
- `collections_controller.rb` - Article collections

**User Management:**
- `dashboards_controller.rb` - User dashboards
- `confirmations_controller.rb` - Email confirmations
- `badges_controller.rb` - Badge display
- `credits_controller.rb` - User credits/karma

**Community Features:**
- `billboards_controller.rb` - Announcements/ads
- `listings_controller.rb` - Classified ads
- `billboard_events_controller.rb` - Ad analytics

**Admin:**
- `admin/` - Administrative interfaces (subdirectory)

---

## Authentication & Authorization

**Authentication Method:** Devise + API Tokens

**Key Files:**
- Authentication logic: `app/controllers/concerns/` (authentication concerns)
- Authorization: Pundit policies in `app/policies/`
- API token management: `api_secrets_controller.rb`

**Common Headers:**
```
api-key: <user_api_secret>
Content-Type: application/json
```

---

## API Response Patterns

**Serialization:** JSONAPI Serializer (`jsonapi-serializer` gem)

**Standard Response Structure:**
```json
{
  "data": {
    "type": "article",
    "id": "123",
    "attributes": { ... }
  }
}
```

**Error Response:**
```json
{
  "errors": [
    {
      "status": "422",
      "detail": "Validation failed"
    }
  ]
}
```

---

## Rate Limiting

**Implementation:** Rack::Attack middleware

**Configuration:** Check `config/initializers/rack_attack.rb`

---

## API Documentation

**Tools:**
- Swagger/OpenAPI: `rswag-specs` gem
- API documentation location: `swagger/` directory
- Interactive docs: Available at `/api-docs` (when enabled)

---

## Notes for Developers

1. **API Versioning:** Always use versioned endpoints (v0, v1) for stability
2. **Pagination:** Most list endpoints support pagination via Kaminari
3. **Filtering:** Many endpoints support ransack-based filtering
4. **CORS:** Configured via `rack-cors` gem for cross-origin requests
5. **Testing:** RSpec request specs in `spec/requests/`

---

**Generated:** 2025-11-09 (Deep Scan)
**Scan Mode:** Pattern-based with critical file reading
