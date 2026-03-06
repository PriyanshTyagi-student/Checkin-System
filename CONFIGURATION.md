# 🔧 Configuration Guide - Check-In System

## Backend URL Configuration

### Why It Matters
The check-in app needs to know where your backend API is located. This changes based on:
- **Local testing**: `http://localhost:5000`
- **Staging**: `https://staging-api.techmnhub.com`
- **Production**: `https://api.techmnhub.com`

## Where to Configure

### File: `checkin/index.html`

**Location**: Line ~395

**Original**:
```javascript
const BACKEND_URL = 'https://your-backend-url.com'; // Update this!
```

### Configuration Examples

#### Example 1: Local Development
```javascript
const BACKEND_URL = 'http://localhost:5000';
```

#### Example 2: Deployed on Vercel
```javascript
const BACKEND_URL = 'https://techmnhub-backend.vercel.app';
```

#### Example 3: Custom Domain
```javascript
const BACKEND_URL = 'https://api.techmnhub.com';
```

#### Example 4: Smart Detection (Recommended)
```javascript
const BACKEND_URL = window.location.hostname === 'localhost' 
  ? 'http://localhost:5000'
  : 'https://api.techmnhub.com';
```

This automatically uses localhost while developing and production URL when deployed!

#### Example 5: Multiple Environments
```javascript
const ENV = {
  development: 'http://localhost:5000',
  staging: 'https://staging-api.techmnhub.com',
  production: 'https://api.techmnhub.com'
};

const currentEnv = window.location.hostname === 'localhost' ? 'development' : 'production';
const BACKEND_URL = ENV[currentEnv];
```

## How to Update

### Step 1: Find the Line
In `index.html`, search for (Ctrl+F):
```
const BACKEND_URL
```

### Step 2: Replace URL
Change from:
```javascript
const BACKEND_URL = 'https://your-backend-url.com';
```

To your actual backend:
```javascript
const BACKEND_URL = 'https://api.techmnhub.com';
```

### Step 3: Save File
Ctrl+S to save.

### Step 4: Test
1. Refresh the page (Ctrl+R)
2. Open browser console (F12)
3. Look for:
   ```
   Backend URL: https://api.techmnhub.com
   Update BACKEND_URL in the code to match your actual backend!
   ```

## Backend CORS Configuration

Your backend must allow requests from your check-in app URL.

### File: `backend/server.js`

**Current CORS setup:**
```javascript
app.use(
  cors({
    origin: [
      "http://localhost:8080",           // Local testing
      "http://127.0.0.1:8080",
      "https://zonex-2026.pages.dev",    // Cloudflare Pages example
      "https://zonex-2026.vercel.app",   // Vercel example
      "https://techmnhub.com",           // Production
      // Add your URLs here
    ],
    credentials: true,
  }),
);
```

### Add Your Check-In URL

When you deploy the check-in app, add its URL to the `origin` array:

#### For Cloudflare Pages
```javascript
origin: [
  "https://your-project.pages.dev",
  // ... other URLs
]
```

#### For Vercel
```javascript
origin: [
  "https://zonex-checkin.vercel.app",
  // ... other URLs
]
```

#### For Custom Domain
```javascript
origin: [
  "https://checkin.techmnhub.com",
  // ... other URLs
]
```

## Testing Connection

### Method 1: Browser Console (Easiest)
1. Open check-in app
2. Press **F12** to open developer tools
3. Go to **Console** tab
4. You'll see the backend URL being used
5. Try entering a Registration ID
6. Check Network tab (F12 > Network) to see API calls

### Method 2: Manual URL Test
1. Open your browser
2. Try accessing: `https://your-backend-url.com/api/checkin/stats`
3. If working, you see JSON with numbers
4. If not working, you get network error

### Method 3: Use Postman
1. Download [Postman](https://www.postman.com/)
2. Create POST request to: `https://your-backend-url.com/api/checkin/verify`
3. Headers: `Content-Type: application/json`
4. Body: `{"registrationId": "ZNX2026-123456"}`
5. Send and check response

## Environment Variables (Optional)

If you want to avoid hardcoding the URL, use environment variables:

### For Cloudflare Pages
1. **Pages** > Your Project > **Settings**
2. **Environment variables** > **Add variable**
3. Name: `BACKEND_URL`
4. Value: `https://api.techmnhub.com`

Then access in JavaScript:
```javascript
const BACKEND_URL = globalThis.BACKEND_URL || 'https://api.techmnhub.com';
```

### For Vercel
1. **Vercel Dashboard** > Project > **Settings**
2. **Environment Variables**
3. Add: `NEXT_PUBLIC_BACKEND_URL`
4. Then use in code: `process.env.NEXT_PUBLIC_BACKEND_URL`

### For Local .env (Not recommended for frontend)
Frontend is static - can't read .env files directly. Must hardcode or use build-time variables.

## Troubleshooting Configuration

| Issue | Cause | Fix |
|-------|-------|-----|
| "Cannot reach backend" | Wrong URL | Check `BACKEND_URL` matches your backend |
| CORS error in console | Missing in CORS origins | Add your frontend URL to backend origins |
| API returns 404 | Wrong endpoint path | Check `/api/checkin/verify` is correct |
| Blank page on load | Syntax error in URL | Check for typos, missing quotes |
| Works locally, fails on deploy | Forgot to update URL | Update `BACKEND_URL` for production |

## Security Best Practices

### ✅ DO
- Use HTTPS in production (`https://...`)
- Limit CORS to specific URLs (not `*`)
- Never expose API keys in frontend (pass via backend)
- Validate input on both frontend and backend

### ❌ DON'T
- Don't use `http://` in production (insecure)
- Don't allow CORS from `*` (security risk)
- Don't put secrets/API keys in frontend code
- Don't trust frontend validation alone

## Regional API Servers

If you have multiple backend servers:

```javascript
// Detect user region and connect accordingly
const region = getUserRegion(); // You must implement this

const BACKEND_URLS = {
  'US': 'https://us-api.techmnhub.com',
  'EU': 'https://eu-api.techmnhub.com',
  'ASIA': 'https://asia-api.techmnhub.com',
  'default': 'https://api.techmnhub.com'
};

const BACKEND_URL = BACKEND_URLS[region] || BACKEND_URLS.default;
```

## Monitoring

### Check API Health
```javascript
// In browser console
fetch('https://api.techmnhub.com/api/checkin/stats')
  .then(r => r.json())
  .then(d => console.log('API is UP:', d))
  .catch(e => console.log('API is DOWN:', e));
```

### Monitor Errors
Add to `index.html`:
```javascript
window.addEventListener('unhandledrejection', event => {
  console.error('API Error:', event.reason);
  // Send to error tracking service
});
```

---

**Need help?** Check the main [README.md](./README.md) for more details!
