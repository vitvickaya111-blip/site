# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a single-file static HTML website for a relocation and emigration consulting business ("Твоя подруга в эмиграции"). The site is entirely self-contained in `relocation-website.html` with embedded CSS and JavaScript.

## Architecture

### Single-File Structure
- **HTML**: All markup is in one file
- **CSS**: Embedded in `<style>` tags (lines 10-977)
- **JavaScript**: Embedded in `<script>` tags (lines 1491-1653)
- **No build process**: Open the HTML file directly in a browser

### Key Sections
1. **Navigation** (lines 993-1004): Fixed navbar with scroll effect
2. **Hero** (lines 1007-1019): Landing section with CTA
3. **About** (lines 1022-1053): Personal story and stats
4. **Services** (lines 1056-1238): 7 service cards with pricing
5. **Testimonials** (lines 1241-1418): Reviews grid + review submission form
6. **Contact** (lines 1421-1464): Contact form
7. **Footer** (lines 1467-1489): Social links and closing CTA

### CSS Architecture
- **CSS Variables** (lines 11-23): Color scheme defined in `:root`
- **Component-based**: Each section has dedicated styles (`.hero`, `.services`, `.testimonials`, etc.)
- **Responsive**: Media queries at 1200px, 968px, and 640px breakpoints (lines 918-976)
- **Animations**: `fadeInUp`, `fadeIn`, `float-around` keyframes for visual effects

### JavaScript Features
1. **Navbar scroll effect** (lines 1492-1500): Adds shadow on scroll
2. **Smooth scrolling** (lines 1502-1514): For anchor links
3. **Telegram integration** (lines 1516-1613):
   - Contact form submission (lines 1544-1573)
   - Review form submission (lines 1576-1613)
   - Requires `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` configuration (lines 1517-1518)
4. **Intersection Observer** (lines 1615-1652): Animates cards on scroll

## Configuration Required

### Telegram Bot Setup
To enable form submissions, update lines 1517-1518:
```javascript
const TELEGRAM_BOT_TOKEN = 'YOUR_BOT_TOKEN_HERE'; // Replace with actual bot token
const TELEGRAM_CHAT_ID = 'YOUR_CHAT_ID_HERE'; // Replace with actual chat ID
```

## Development Workflow

### Viewing the Site
```bash
# Option 1: Open directly in browser
open relocation-website.html

# Option 2: Use a local server (if needed for testing)
python3 -m http.server 8000
# Then visit http://localhost:8000/relocation-website.html
```

### Making Changes
1. Edit `relocation-website.html` directly
2. Refresh browser to see changes
3. No build or compilation needed

### Testing Forms
- Forms require valid Telegram bot credentials
- Without credentials, forms will show fallback message directing to Telegram
- Test both contact form (#contactForm) and review form (#reviewForm)

## Design System

### Colors
- **Primary gradient**: Pink (#FF6B9D) to Purple (#A855F7)
- **Backgrounds**: Dark theme (#0A0A0A, #1A1A1A, #2A2A2A)
- **Text**: White (#FFFFFF) and gray (#AAAAAA)
- **Accents**: Blue, Yellow, Green, Orange (defined in CSS variables)

### Typography
- **Headings**: 'Playfair Display' (serif, elegant)
- **Body**: 'Inter' (sans-serif, modern)
- Loaded from Google Fonts (lines 7-9)

### Components
- **Service cards**: Grid layout, 3 columns → 2 → 1 (responsive)
- **Stat cards**: 2x2 grid with gradient top border
- **Telegram reviews**: Chat-like cards with avatar gradients
- **Buttons**: Gradient background with hover animations

## Deployment & CI/CD

### Automatic Deployment
- **GitHub Actions** workflow: `.github/workflows/deploy.yml`
- **Triggers**: Automatic on push to `main` branch, or manual via Actions tab
- **Method**: SSH deployment to VPS server
- **Deploy script**: `deploy.sh` (runs on server)

### Required GitHub Secrets
Set these in **Settings → Secrets and variables → Actions**:
- `SERVER_HOST`: Server IP or domain
- `SERVER_USER`: SSH username
- `SSH_PRIVATE_KEY`: Private SSH key for authentication
- `SERVER_PORT`: SSH port (default: 22)
- `PROJECT_PATH`: Path on server (default: /var/www/site)

### Deployment Process
1. Push changes to `main` branch
2. GitHub Actions triggers automatically
3. Connects to server via SSH
4. Pulls latest changes from repository
5. Copies files to web root
6. Sets correct permissions
7. Optional: Reloads web server

### Manual Deployment
SSH into server and run:
```bash
cd /var/www/site
./deploy.sh
```

### Setup Instructions
See `DEPLOYMENT.md` for complete setup guide including:
- Server configuration
- SSH key generation
- GitHub Secrets setup
- Web server configuration (nginx/apache)
- SSL certificate setup
- Troubleshooting

## Git Status
- Repository: `git@github.com:vitvickaya111-blip/site.git`
- Remote: `origin`
- Branch: `main`

## Common Tasks

### Update Service Pricing
Edit the `.price` div within each `.service-card` (lines 1061-1235)

### Add New Service
Copy a `.service-card` block and update:
- `.service-badge` text
- `.service-image` src
- `.service-title`, `.service-description`
- `.service-features` list items
- `.price` and `.price-label`

### Modify Color Scheme
Update CSS variables in `:root` (lines 11-23)

### Add New Review
Add a new `.telegram-review` div in the testimonials grid (lines 1245-1383)

### Update Contact Links
- Instagram: lines 1449, 1473
- Telegram: lines 1453, 1477
- Bot: lines 1457, 1481