# 📱 Zonex 2026 Check-In System

A complete QR code-based check-in system for event participant verification. Features real-time scanning, manual entry, and statistics tracking.

## ✨ Features

- **QR Code Scanning** - Real-time QR code detection via device camera
- **Manual Entry** - Fallback option to manually enter Registration IDs
- **Instant Verification** - Verify tickets against backend database
- **Check-In Tracking** - Mark participants as checked-in with timestamp
- **Live Statistics** - Track total scans, check-ins, and failures
- **Activity Log** - Recent 20 activities with names and timestamps
- **LocalStorage Persistence** - Stats saved locally (survives page refresh)
- **Offline Support** - Works offline if backend is initially loaded
- **Mobile Friendly** - Responsive design for both desktop and mobile
- **Cloudflare Pages Ready** - Deploy as static site (no server needed)

## 📋 Setup Instructions

### Prerequisites

- Node.js backend running (see Backend Setup below)
- Browser with camera permission for QR scanning
- Static hosting (Cloudflare Pages, Vercel, Netlify, etc.)

### Option 1: Local Testing (Development)

1. **Open in Browser (via HTTP, not file://)**
   ```bash
   cd checkin
   python -m http.server 8080
   # Access: http://localhost:8080/index.html
   ```

2. **Update Backend URL** (in `index.html` line ~395)
   ```javascript
   const BACKEND_URL = 'http://localhost:5000';
   ```

3. **Grant Camera Permission** when prompted

### Option 2: Deploy to Cloudflare Pages

1. **Update Backend URL** in `index.html`:
   ```javascript
   // Replace with your actual backend URL
   const BACKEND_URL = 'https://your-api.example.com';
   ```

2. **Connect to Cloudflare Pages**
   - Go to Cloudflare Pages > Create Project > Connect Git
   - Select the repository
   - Build Settings: Leave default (no build command needed)
   - Root directory: `checkin`
   - Deploy!

3. **Enable CORS on Backend**
   - Add your Cloudflare Pages URL to backend CORS:
   ```javascript
   // In backend/server.js
   origin: [
     "https://your-project.pages.dev",
     // ... other origins
   ]
   ```

4. **Access**
   ```
   https://your-project.pages.dev/index.html
   ```

## 🔧 Backend Setup

### Routes Required

The backend must have these endpoints:

#### 1. Verify Registration
```
POST /api/checkin/verify
Content-Type: application/json

{
  "registrationId": "ZNX2026-123456"
}

Response:
{
  "msg": "Registration verified",
  "user": {
    "_id": "...",
    "fullName": "John Doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "college": "BITS Pilani",
    "category": "Student",
    "subCategory": ["Web Dev", "AI/ML"],
    "registrationId": "ZNX2026-123456",
    "passName": "Early Bird",
    "checkedIn": false,
    ...
  }
}
```

#### 2. Check-In Participant
```
POST /api/checkin/checkin
Content-Type: application/json

{
  "registrationId": "ZNX2026-123456",
  "userId": "user_mongo_id"
}

Response:
{
  "msg": "Check-in successful",
  "user": { ... },
  "checkedInAt": "2026-03-07T10:30:00Z"
}
```

#### 3. Get Statistics
```
GET /api/checkin/stats

Response:
{
  "total": 500,
  "checkedIn": 250,
  "pending": 250,
  "checkinPercentage": 50
}
```

### Server.js Configuration

Already configured! Routes are imported as:
```javascript
const checkinRoutes = require("./routes/checkinRoutes");
app.use("/api/checkin", checkinRoutes);
```

## 📱 Usage Guide

### Scanner Tab (QR Code Mode)
1. Click **🎥 Start Scanner**
2. Grant camera permission
3. Point device camera at QR code on participant's ticket
4. System automatically detects and verifies
5. Participant info displays with **Check-In** button

### Manual Tab (Registration ID Entry)
1. Enter Registration ID manually (format: `ZNX2026-XXXXXX`)
2. Click **Verify & Check-In**
3. System fetches participant details
4. Review and confirm check-in

### Stats Tab (Live Dashboard)
- **Total Scanned** - How many tickets have been verified
- **Checked In** - How many participants are checked-in
- **Failed** - How many verification attempts failed
- **Recent Activity** - Last 20 activities with timestamps
- **Clear Stats** - Reset all statistics

## 🔍 Participant Info Display

When ticket is verified, shows:
- ✅ Check-In Status (Pending / Already Checked In)
- Full Name
- Email & Mobile
- College / Institution
- Registration Category & Activities
- Pass Type (Early Bird, Premium, etc.)
- Previous Check-In Timestamp (if already checked in)

### Two-Click Check-In
1. Verify ticket (automatic via QR or manual entry)
2. Click **✅ Check-In** button
3. System marks as checked-in with timestamp
4. Cannot check-in twice (button disabled if already checked-in)

## 💾 Data Persistence

### Frontend (LocalStorage)
- Statistics saved locally
- Activity log (last 20 entries)
- Persists across page refreshes
- Does NOT sync to server

### Backend (MongoDB)
- User document updated with:
  - `checkedIn: true`
  - `checkInTime: timestamp`
- Persists across all sessions
- Can be queried for reports

## 🎯 Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "Cannot reach backend" | Backend server down | Start backend: `npm start` |
| "Registration not found" | Invalid Registration ID | Check ID format: `ZNX2026-XXXXXX` |
| "Camera error" | No camera permission | Grant permission in browser settings |
| "CORS error" | Wrong backend URL | Update `BACKEND_URL` in index.html |
| "Already checked in" | Participant already scanned | Is expected - system prevents duplicate |

## 🚀 Deployment Checklist

- [ ] Backend URL updated in `index.html` (line ~395)
- [ ] Backend server is running and accessible
- [ ] CORS enabled for your frontend URL on backend
- [ ] Database connection working (MongoDB)
- [ ] Test verify endpoint: `/api/checkin/verify`
- [ ] Test checkin endpoint: `/api/checkin/checkin`
- [ ] Deploy to Cloudflare Pages (or similar)
- [ ] Grant camera permission in browser
- [ ] Test with real QR code from ticket system

## 📊 Cloudflare Pages Deployment Steps

### Step 1: Prepare Repository
```bash
# Ensure checkin folder is ready at root
# index.html should be at: /checkin/index.html
```

### Step 2: Connect to Cloudflare
1. Login to Cloudflare > Pages
2. Click "Create a project"
3. Select "Connect to Git"
4. Choose your repository
5. Click "Begin setup"

### Step 3: Configure Build Settings
- **Production branch**: `main` (or your branch)
- **Build command**: (leave empty - static site)
- **Build output directory**: `checkin`
- **Environment variables**: None needed

### Step 4: Deploy
- Click "Save and Deploy"
- Wait for build to complete
- Access at: `https://your-project.pages.dev`

### Step 5: Update Backend CORS
```javascript
// backend/server.js
cors({
  origin: [
    "https://your-project.pages.dev",
    "http://localhost:8080",
    // ... other origins
  ]
})
```

## 🛠️ Configuration

### Change Backend URL
Edit `index.html` around **line 395**:
```javascript
const BACKEND_URL = 'https://your-backend-url.com';
```

### Customize Styling
- **Colors**: Search for `#06b6d4` (cyan), modify CSS variables
- **Branding**: Update header text and logo
- **Layout**: Modify grid and flexbox in CSS

### Add Features
The frontend is vanilla JavaScript - easy to extend:
- Add photo capture for participant ID verification
- SMS/Email notifications on check-in
- Export CSV reports
- Offline QR code validation (store codes locally)

## 📞 Support

### Common Issues

**Q: Camera not working**
- A: Check browser permissions: Settings > Privacy > Camera

**Q: "Cannot connect to backend"**
- A: Ensure backend URL is correct and CORS is enabled

**Q: QR code not detected**
- A: Ensure good lighting, QR code is visible, camera is focused

**Q: Participant already checked in but trying again**
- A: Expected behavior - duplicate check-ins are prevented

## 📄 License

Part of TechMNHub - Zonex 2026 Event System

---

**Event**: Zonex 2026 (March 7, 2026)  
**Location**: TechMNHub  
**System**: Real-time Participant Check-In with QR Code Scanning
