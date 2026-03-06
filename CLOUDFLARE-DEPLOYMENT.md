# 🚀 Deploy Check-In System to Cloudflare Pages

Complete step-by-step guide for deploying the Zonex 2026 check-in system.

## Prerequisites

- GitHub repository with `/checkin` folder
- Cloudflare account (free tier is fine)
- Backend API running and accessible online

## Step 1: Update Backend URL

**File**: `checkin/index.html` (line ~395)

**Before**:
```javascript
const BACKEND_URL = 'https://your-backend-url.com';
```

**After** (example):
```javascript
const BACKEND_URL = 'https://api.techmnhub.com'; // Your actual backend URL
```

**Or with environment-specific logic**:
```javascript
const BACKEND_URL = window.location.hostname === 'localhost' 
  ? 'http://localhost:5000' 
  : 'https://api.techmnhub.com';
```

## Step 2: Configure Backend CORS

Update your backend `server.js` to allow your Cloudflare Pages URL:

```javascript
app.use(
  cors({
    origin: [
      "https://zonex-2026.pages.dev",  // Your Cloudflare Pages URL
      "https://your-domain.com",        // Production domain (if custom)
      "http://localhost:8080",
      "http://localhost:5000",
      // ... other origins
    ],
    credentials: true,
  }),
);
```

**Important**: Replace `zonex-2026.pages.dev` with your actual project name!

## Step 3: Connect to Cloudflare Pages

### Option A: Via Git (Recommended)

1. **Login to Cloudflare**
   - Go to [dash.cloudflare.com](https://dash.cloudflare.com)
   - Select your account

2. **Navigate to Pages**
   - Left sidebar → Pages
   - Click **Create a project**

3. **Connect repository**
   - Click **Connect to Git**
   - Select GitHub/GitLab/Gitea
   - Authorize and select your repository
   - Click **Connect**

4. **Configure build**
   - **Production branch**: `main` (or whatever your branch is)
   - **Build command**: (leave empty)
   - **Build output directory**: `checkin`
   - **Root directory**: (optional - can also be `/`)

5. **Deploy**
   - Click **Save and Deploy**
   - Wait 1-2 minutes
   - Your site is live!

### Option B: Direct Upload (For testing)

1. **Create ZIP file**
   ```bash
   cd checkin
   # zip everything except node_modules (.gitignore)
   ```

2. **Upload to Cloudflare**
   - Pages > Create Project > Upload Assets
   - Drag and drop the folder or ZIP
   - Done!

## Step 4: Get Your Cloudflare Pages URL

After deployment, Cloudflare automatically generates:
```
https://<project-name>.<branch>.pages.dev
```

**Example**:
```
https://zonex-checkin.main.pages.dev
```

You can customize this with a custom domain or path.

## Step 5: Test the System

1. **Access check-in app**
   ```
   https://zonex-checkin.main.pages.dev/index.html
   ```

2. **Test verification**
   - Go to "Manual" tab
   - Enter a valid Registration ID (e.g., `ZNX2026-123456`)
   - Click "Verify & Check-In"
   - Should display participant info

3. **Test QR scanner**
   - Go to "Scanner" tab
   - Point camera at actual QR code
   - Should detect and verify

4. **Check statistics**
   - Go to "Stats" tab
   - Should show scan counts
   - Activity log should update

## Optional: Add Custom Domain

### Using Cloudflare Registrar

1. **Pages > Custom domains**
2. **Add domain**
3. **Choose: Use Cloudflare nameservers** (if already using Cloudflare)

### Using External Registrar

1. **Pages > Custom domains**
2. **Add domain**
3. **Choose: Use CNAME** 
4. **Copy CNAME record** to your registrar
5. **Wait for DNS propagation** (can take 24-48 hours)

## Security Considerations

### CORS Configuration
✅ **Only allow your frontend URL**:
```javascript
origin: ["https://zonex-2026.pages.dev"]
```

❌ **Don't use wildcard**:
```javascript
origin: "*"  // ❌ Insecure
```

### Environment Variables
If you need sensitive data, use Cloudflare Secrets:
```bash
# Set via Cloudflare dashboard
CF_SECRET_KEY=your_secret_value
```

Then access in code:
```javascript
const secretKey = globalThis.CF_SECRET_KEY;
```

### Rate Limiting
Backend should have rate limiting on check-in endpoint:
```javascript
const checkInLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 10 // 10 checks per minute per IP
});

app.use("/api/checkin/checkin", checkInLimiter, checkInParticipant);
```

## Troubleshooting Deployment

| Issue | Solution |
|-------|----------|
| 404 Not Found | Build output dir is wrong (should be `checkin`) |
| Blank page | Check browser console (F12) for JavaScript errors |
| Cannot reach backend | Update BACKEND_URL in index.html |
| CORS error in console | Add your Pages URL to backend CORS origins |
| Camera not working | Check browser permissions - allow camera access |
| Stats not persisting | LocalStorage might be disabled - use browser defaults |

## Performance Optimization

### Already Optimized
- ✅ Inline CSS (no external files)
- ✅ Lightweight QR scanner (~60KB)
- ✅ No framework dependencies (vanilla JS)
- ✅ Static assets (Cloudflare caches automatically)

### Additional Steps (Optional)
1. **Enable Cloudflare Caching**
   - Dashboard > Caching > Cache Level: "Cache Everything"

2. **Enable Compression**
   - Dashboard > Speed > Enable Brotli

3. **Minimize Requests**
   - Uses only two external libraries (jsQR)

## Monitoring & Analytics

### Cloudflare Dashboard
- Pages > Your project > Analytics tab
- Track requests, errors, performance

### Custom Error Tracking
Add to `index.html` for error reporting:
```javascript
// Send errors to your backend
window.addEventListener('error', (e) => {
  fetch('https://api.techmnhub.com/logs', {
    method: 'POST',
    body: JSON.stringify({
      error: e.message,
      stack: e.error?.stack,
      timestamp: new Date()
    })
  });
});
```

## Rollback/Revert

If something breaks:

1. **Via Cloudflare Dashboard**
   - Pages > Your project > Deployments
   - Select previous deployment
   - Click "Rollback"

2. **Via Git**
   - Revert commit with bad code
   - Push to main branch
   - Auto-redeploys in minutes

## Next Steps

1. ✅ Deploy to Cloudflare Pages
2. ✅ Test with backend API
3. ✅ Distribute URL to event staff
4. ✅ Monitor check-in stats during event
5. ✅ Export final check-in records post-event

---

**Questions?**

For issues:
1. Check browser console: **F12 → Console tab**
2. Check Cloudflare logs: **Pages > Analytics**
3. Verify backend is running: Try `/api/checkin/stats` in Postman
4. Check backend CORS: Add your Pages URL to origins list
