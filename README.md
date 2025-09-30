# Nosso Contador 📊

A real-time counter application built with **Phoenix LiveView** that allows users to increase, decrease, and save counter values with internationalization support.

## 🚀 Features

- **Real-time Counter**: Instant updates using Phoenix LiveView
- **Data Persistence**: Counter values saved to PostgreSQL database
- **Internationalization**: Full support for Portuguese and English
- **Smart Notifications**: Toast notifications in the bottom-right corner
- **Responsive Design**: Works on desktop and mobile devices
- **Language Toggle**: Easy switching between languages with dropdown
- **History Tracking**: View last 5 saved counter values

## 🛠 Tech Stack

- **Elixir** + **Phoenix Framework** + **LiveView**
- **PostgreSQL** for data persistence
- **Tailwind CSS** for styling
- **Gettext** for internationalization
- **Ecto** for database operations

## 📋 Prerequisites

- Elixir 1.15+
- Erlang OTP 26+
- PostgreSQL 12+
- Node.js 18+

## 🏃‍♂️ Quick Start

### 1. Clone and Setup

```bash
git clone <repository-url>
cd nosso_contador

# Copy environment configuration
cp .env.example .env

# Edit .env with your database credentials
# Update DB_USERNAME, DB_PASSWORD, etc. as needed
```

### 2. Load Environment Variables

```bash
# Load environment variables (Linux/Mac)
source .env

# Windows (Command Prompt)
# .env

# Windows (PowerShell)
# Get-Content .env | ForEach-Object { if ($_ -match '^([^=]+)=(.*)$') { [Environment]::SetEnvironmentVariable($matches[1], $matches[2]) } }
```

### 3. Install Dependencies

```bash
# Elixir dependencies
mix deps.get

# JavaScript dependencies
cd assets && npm install && cd ..
```

### 4. Database Setup

```bash
# Create database
mix ecto.create

# Run migrations
mix ecto.migrate
```

### 5. Start the Server

```bash
mix phx.server
```

Visit: http://localhost:4000

## 🔧 Environment Configuration

### Required Environment Variables

Create a `.env` file based on `.env.example`:

```bash
# Database Configuration
export DB_USERNAME=your_postgres_username
export DB_PASSWORD=your_postgres_password
export DB_NAME=nosso_contador_dev
export DB_HOST=localhost
export DB_PORT=5432
```

### Setting Up PostgreSQL User

If using the provided `.env.example` credentials:

```sql
-- Connect to PostgreSQL as admin
psql postgres

-- Create user and database
CREATE USER nosso_contador WITH PASSWORD 'nosso_contador';
CREATE DATABASE nosso_contador_dev OWNER nosso_contador;
GRANT ALL PRIVILEGES ON DATABASE nosso_contador_dev TO nosso_contador;
```

### Alternative: Using Existing PostgreSQL Credentials

If you have an existing PostgreSQL setup, update your `.env`:

```bash
DB_USERNAME=postgres
DB_PASSWORD=your_actual_password
```

## 🌍 Internationalization

The app supports two languages:

- **English** (default): `?locale=en`
- **Portuguese**: `?locale=pt`

### Language Detection Priority:
1. URL parameter (`?locale=pt`)
2. Session storage
3. Browser accept-language header
4. Default: English

## 🗃 Database Schema

### Counter Values Table
```elixir
# Stores all saved counter values
table :counter_values do
  field :value, :integer
  timestamps()  # inserted_at used for ordering
end
```

## 🎯 Key Design Decisions

### 1. Architecture
- **Phoenix LiveView** for real-time updates without JavaScript
- **Repository Pattern** with Ecto for data access
- **Plug-based** locale detection system

### 2. User Experience
- **Toast Notifications**: Non-intrusive bottom-right notifications
- **Smart Saving**: Prevents saving duplicate values consecutively
- **Persistent State**: Counter starts with last saved value
- **Visual Feedback**: Color-coded notifications (success/warning)

### 3. Code Organization
```
lib/
├── nosso_contador/
│   ├── counter.ex                 # Schema and business logic
│   └── repo.ex
├── nosso_contador_web/
│   ├── live/
│   │   └── counter_live.ex        # LiveView handling
│   ├── plugs/
│   │   └── locale.ex              # Locale detection plug
│   └── gettext/                   # Translation files
```

### 4. Internationalization Strategy
- **Gettext** with .po files for translations
- **Locale Plug** handles detection and setting
- **Fallback System** ensures always having a valid locale
- **Session Storage** remembers user preference

## 🧪 Testing

Run the test suite:

```bash
# All tests
mix test

# Specific test files
mix test test/nosso_contador/counter_test.exs
mix test test/nosso_contador_web/live/counter_live_test.exs

# With coverage
mix test --cover
```

### Test Structure:
- **Counter Tests**: Schema validation and database queries
- **LiveView Tests**: User interactions and UI updates
- **Plug Tests**: Locale detection logic
- **Gettext Tests**: Translation accuracy

## 📁 Project Structure

```
nosso_contador/
├── lib/
│   ├── nosso_contador/
│   │   ├── counter.ex
│   │   └── repo.ex
│   └── nosso_contador_web/
│       ├── live/counter_live.ex
│       ├── plugs/locale.ex
│       └── gettext/
├── assets/
│   ├── js/app.js                  # LiveView hooks & notifications
│   └── css/app.css               # Tailwind & custom styles
├── priv/
│   ├── repo/migrations/          # Database migrations
│   └── gettext/                  # Translation files
└── test/                         # Comprehensive test suite
```

## 🎨 UI Components

### Counter Interface
- Large counter display
- Three action buttons (Decrease/Increase/Save)
- Real-time updates
- Visual feedback on interactions

### Notifications System
- **Position**: Bottom-right corner
- **Types**: Success (green), Warning (yellow)
- **Auto-dismiss**: 4 seconds
- **Manual close**: Click × button
- **Smooth animations**: Slide-in effects

### Language Selector
- Dropdown in header
- Flag icons + language names
- Current selection highlighted
- Persistent across sessions

## 🚀 Deployment

### Production Build
```bash
MIX_ENV=prod mix release
```

## 📝 Development Notes

### Adding New Languages
1. Add locale to `Gettext.known_locales/1`
2. Create new .po file in `priv/gettext/{locale}/LC_MESSAGES/default.po`
3. Update locale plug to recognize new locale

### Adding New Counter Actions
1. Add event handler in `counter_live.ex`
2. Update UI in `counter_live.html.heex`
3. Add tests in `counter_live_test.exs`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Phoenix Framework team for LiveView
- Elixir community for excellent tooling
- Tailwind CSS for utility-first styling

---

**Happy Counting!** 🎯