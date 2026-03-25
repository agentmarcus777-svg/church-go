# Church Go — Product Specification

## Tagline
**"Follow in His Footsteps"**

## Concept
Pokémon Go but for visiting churches worldwide. GPS-based check-in app with badge progression, collection mechanics, and gamification. Duolingo-level polish and game-like feel.

---

## Tech Stack
- **Mobile:** SwiftUI (iOS native only)
- **Backend:** Supabase ONLY (Postgres + Auth + Edge Functions + Storage)
- **Maps:** Apple MapKit (free, native)
- **Church Data:** OpenStreetMap Overpass API (primary, free — amenity=place_of_worship)
- **Storage:** Supabase Storage (photos)
- **Deployment:** Xcode → TestFlight → App Store
- **Apple Developer Team:** 3M2R686D9V

---

## Design System

### Colors
- **Primary:** Crimson Red (#C41E3A)
- **Secondary:** Royal Gold (#D4AF37)
- **Accent:** Deep Red (#8B0000)
- **Background:** Ivory (#FFFFF0)
- **Text:** Dark Charcoal (#333333)
- **Surface:** White with subtle warm shadows

### Typography
- SF Rounded (system) — bold, playful headings
- Large, chunky Duolingo-style buttons with rounded corners (16px+ radius)
- Card-based UI with depth and warm shadows

### Visual Style
- Church crusader meets luxury
- Stained glass color inspiration
- Custom map pins (not default Apple red pins) — gold cross on crimson circle
- Game-like UI: progress bars, XP counters, level indicators visible everywhere

---

## Open Source Dependencies (SPM)

### Animation & Polish
- **Lottie** (airbnb/lottie-ios) — After Effects animations for celebrations, badge unlocks, onboarding
- **Rive** (rive-app/rive-ios) — Interactive state-machine animations for mascot/character
- **ConfettiSwiftUI** (simibac/ConfettiSwiftUI) — Confetti explosions on badge unlocks
- **Pow** (EmergeTools/Pow) — Particle effects and springy transitions

### UI Enhancement
- **SDWebImageSwiftUI** (SDWebImage/SDWebImageSwiftUI) — Async image loading with caching
- **PopupView** (exyte/PopupView) — Beautiful toasts, achievement popups

### Native Frameworks
- MapKit — Church map with custom annotations
- CoreLocation — GPS check-in validation
- CoreHaptics — Satisfying haptic feedback on check-ins
- UIImpactFeedbackGenerator — Haptic on every interaction

---

## Screens & Navigation

### Tab Bar (4 tabs)
1. **Explore** (map icon) — Map view with church pins
2. **Collection** (grid icon) — Stamp passport grid of visited churches
3. **Badges** (trophy icon) — Badge wall with progress
4. **Profile** (person icon) — Stats, level, streak, settings

### Screen Details

#### 1. Onboarding (first launch)
- Welcome screen: "Collect churches like Pokémon"
- "Follow in His Footsteps" tagline with animated cross/church illustration
- Location permission request with clear explanation
- Sign up / Sign in (Supabase Auth — email + Apple Sign In)

#### 2. Explore (Map Tab)
- Full-screen MapKit view
- Custom church pin annotations (gold cross on crimson circle)
- Cluster annotations when zoomed out
- Tap pin → Church detail card slides up:
  - Church name, denomination, address
  - Photo (if available from Google Places)
  - Distance from user
  - "Check In" button (only enabled within 50m)
  - Wikipedia link for history
- Current location button
- Search bar at top for finding specific churches

#### 3. Check-In Flow
- Tap "Check In" on church detail card
- GPS validation: must be within 50 meters
- Success: 
  - Full-screen Lottie celebration animation
  - Confetti burst (ConfettiSwiftUI)
  - XP gained popup (+50 base, +100 if new church, +50 if historic, +25 streak bonus)
  - Haptic feedback (CoreHaptics medium impact)
  - Optional: take a selfie/photo (saved to Supabase Storage)
  - Badge unlock animation if milestone hit
- Failure (too far): "Get closer! You're Xm away" with distance indicator

#### 4. Collection Tab (Stamp Passport)
- Grid of visited churches as "stamps" (visual passport-style cards)
- Each stamp: church photo/icon, name, date visited, city
- Filter by: city, state, country, denomination
- Sort by: date visited, alphabetical
- Total count prominent at top
- Empty state: "Start collecting! Your first church awaits."

#### 5. Badges Tab
- Badge wall — grid of all available badges
- Locked badges: grayed out with progress indicator
- Unlocked badges: full color with unlock date
- Tap badge → detail view with requirements and progress bar
- Next badge to unlock highlighted at top

#### 6. Profile Tab
- Avatar (from Apple account or photo)
- Username and level
- XP bar with progress to next level
- Stats dashboard:
  - Total churches visited
  - Countries visited
  - States visited
  - Cities visited
  - Current streak (consecutive days)
  - Longest streak
- Leaderboard button (weekly + all-time)
- Settings (notifications, account, logout)

#### 7. Leaderboard
- Weekly and All-Time tabs
- Top 100 users with rank, avatar, username, church count
- User's own rank highlighted
- Animated rank changes

---

## Gamification System

### XP System
- **Base check-in:** 50 XP
- **New church (first visit):** +100 XP bonus
- **Historic church (100+ years):** +50 XP bonus
- **Streak bonus:** +25 XP per consecutive day
- **Level formula:** Level = floor(sqrt(totalXP / 100))
- Levels 1–100

### Streak System
- Consecutive days with at least one check-in
- Fire animation (Lottie) on streak counter
- Streak freeze: 1 free per week (like Duolingo)
- Streak milestones: 7, 30, 100, 365 days

### Badge Progression
**Local:**
- 🏠 First Steps — 1st church ever
- 🏘️ Neighborhood Explorer — 5 churches in one city
- 🏙️ City Faithful — 10 churches in one city
- 👑 City Champion — ALL churches in a city

**Regional:**
- 🗺️ Regional Pilgrim — 5 churches in metro area
- 🌄 Regional Master — 25 churches in region

**State:**
- ⭐ State Visitor — 10 churches in one state
- 🌟 State Explorer — 50 churches in one state
- 💫 State Legend — 100 churches in one state

**Country:**
- 🇺🇸 Patriot — Churches in 10 states
- 🦅 National Explorer — Churches in 25 states
- 🏆 Coast to Coast — ALL 50 states

**World:**
- ✈️ International — 1st church outside home country
- 🌍 World Traveler — 5 countries
- 🌎 Globe Trotter — 10 countries
- 🌏 World Champion — 25 countries
- 🏛️ Per-country unique badge for each country visited

---

## Database Schema (Supabase Postgres)

### churches
```sql
CREATE TABLE churches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  osm_id BIGINT UNIQUE,
  name TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address TEXT,
  city TEXT,
  state TEXT,
  country TEXT DEFAULT 'US',
  denomination TEXT,
  photo_url TEXT,
  is_historic BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_churches_location ON churches USING gist (
  point(longitude, latitude)
);
CREATE INDEX idx_churches_city ON churches (city, state);
```

### profiles
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  username TEXT UNIQUE NOT NULL,
  avatar_url TEXT,
  total_xp INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_checkin_date DATE,
  streak_freezes INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### checkins
```sql
CREATE TABLE checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) NOT NULL,
  church_id UUID REFERENCES churches(id) NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  photo_url TEXT,
  xp_earned INTEGER NOT NULL,
  checked_in_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, church_id, checked_in_date)
);

CREATE INDEX idx_checkins_user ON checkins (user_id);
```

### badges
```sql
CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  emoji TEXT,
  category TEXT NOT NULL, -- local, regional, state, country, world
  requirement_type TEXT NOT NULL,
  requirement_value INTEGER NOT NULL,
  requirement_scope TEXT -- city name, state name, country code, etc.
);
```

### user_badges
```sql
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) NOT NULL,
  badge_id UUID REFERENCES badges(id) NOT NULL,
  unlocked_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);
```

---

## Church Data Pipeline

### Source: OpenStreetMap Overpass API
Query for `amenity=place_of_worship` + `religion=christian` in top 50 US metros.

Example query:
```
[out:json][timeout:60];
area["name"="Los Angeles"]["admin_level"="8"]->.searchArea;
(
  node["amenity"="place_of_worship"]["religion"="christian"](area.searchArea);
  way["amenity"="place_of_worship"]["religion"="christian"](area.searchArea);
);
out center;
```

### Target: ~15,000 churches for MVP (top 50 US metros)
- Parse name, lat/lng, address from OSM tags
- Store denomination from `denomination` tag
- Batch insert to Supabase

---

## Supabase Edge Functions

### check-in
- Validate GPS proximity (50m radius using Haversine formula)
- Calculate XP (base + bonuses)
- Update streak
- Check badge unlock conditions
- Return: xp_earned, new_badges[], streak_count, level_up boolean

### leaderboard
- Weekly: aggregate XP from last 7 days
- All-time: total_xp from profiles
- Return top 100 + user's rank

---

## MVP Scope (What MUST work)

✅ GPS check-in with proximity validation
✅ Badge unlocks with celebration animations
✅ Map with church pins (custom styled)
✅ Profile with stats, XP, level, streak
✅ Collection view (stamp passport grid)
✅ Leaderboard (weekly + all-time)
✅ Onboarding flow
✅ Apple Sign In + email auth
✅ No crashes, smooth 60fps animations
✅ Privacy policy
✅ Good App Store screenshots

## NOT Building (Post-Launch)
❌ Social feed
❌ Friend system
❌ Reviews/ratings
❌ Pilgrimage routes
❌ Premium subscriptions
❌ Church histories (link to Wikipedia)
❌ Android version (week 2)
❌ Push notifications (post-launch)

---

## File Structure

```
ChurchGo/
├── ChurchGo.xcodeproj/
├── ChurchGo/
│   ├── App/
│   │   ├── ChurchGoApp.swift
│   │   └── ContentView.swift
│   ├── Core/
│   │   ├── Design/
│   │   │   ├── ChurchGoTheme.swift      # Colors, typography, constants
│   │   │   ├── ChunkyButton.swift       # Duolingo-style buttons
│   │   │   └── Components/              # Reusable UI components
│   │   ├── Services/
│   │   │   ├── SupabaseService.swift    # Supabase client
│   │   │   ├── LocationService.swift    # GPS/CoreLocation
│   │   │   ├── CheckInService.swift     # Check-in logic
│   │   │   └── BadgeService.swift       # Badge evaluation
│   │   └── Models/
│   │       ├── Church.swift
│   │       ├── Profile.swift
│   │       ├── CheckIn.swift
│   │       └── Badge.swift
│   ├── Features/
│   │   ├── Onboarding/
│   │   │   └── OnboardingView.swift
│   │   ├── Map/
│   │   │   ├── MapView.swift
│   │   │   ├── ChurchPinView.swift
│   │   │   └── ChurchDetailCard.swift
│   │   ├── CheckIn/
│   │   │   ├── CheckInView.swift
│   │   │   └── CelebrationView.swift
│   │   ├── Collection/
│   │   │   ├── CollectionView.swift
│   │   │   └── StampCard.swift
│   │   ├── Badges/
│   │   │   ├── BadgesView.swift
│   │   │   └── BadgeDetailView.swift
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift
│   │   │   └── StatsView.swift
│   │   └── Leaderboard/
│   │       └── LeaderboardView.swift
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   ├── Animations/               # Lottie JSON files
│   │   └── Fonts/
│   └── Supabase/
│       ├── migrations/
│       └── functions/
│           ├── check-in/
│           └── leaderboard/
└── Package.swift                      # SPM dependencies
```

---

## Build Instructions

1. Create Xcode project: `ChurchGo` with SwiftUI lifecycle
2. Add SPM dependencies:
   - https://github.com/airbnb/lottie-ios.git
   - https://github.com/rive-app/rive-ios.git  
   - https://github.com/simibac/ConfettiSwiftUI.git
   - https://github.com/EmergeTools/Pow.git
   - https://github.com/SDWebImage/SDWebImageSwiftUI.git
   - https://github.com/exyte/PopupView.git
   - https://github.com/supabase-community/supabase-swift.git
3. Set deployment target: iOS 17.0
4. Set bundle ID: com.churchgo.app
5. Set team: 3M2R686D9V
6. Build and archive for TestFlight

---

## Important Notes
- This is a 72-hour sprint to App Store SUBMISSION
- TestFlight build needed by end of Day 1 (basic map + auth + check-in)
- App must feel like a GAME, not a utility
- Duolingo is the UX benchmark — chunky, colorful, animated, satisfying
- Every interaction should have haptic feedback
- Animations on everything: screen transitions, button presses, badge unlocks
- The app should make people WANT to visit churches just to see the next animation
