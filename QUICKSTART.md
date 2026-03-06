# ⚡ Quick Start - Check-In System

Get the check-in system running in 5 minutes.

## 1️⃣ Backend Setup (Already Done)

Backend routes are already configured:
- ✅ `/api/checkin/verify` - Verify ticket exists
- ✅ `/api/checkin/checkin` - Mark as checked-in  
- ✅ `/api/checkin/stats` - Get statistics

**Start backend** (if not running):
```bash
cd backend
npm start
```

Expected output:
```
🚀 Server running on port 5000
...
✅ MongoDB Connected
```

## 2️⃣ Local Testing (5 minutes)

### Option 1: Using HTTP Server (Recommended)

```bash
cd checkin
python -m http.server 8080
```

Then open: **http://localhost:8080/index.html**

✅ Works! System is ready to use.

### Option 2: Using Node.js

```bash
cd checkin
npx http-server . -p 8080
```

Same result - opens on port 8080.

## 3️⃣ First Test

1. **Open Scanner Tab** 🎥
   - Click "Start Scanner"
   - Allow camera permission

2. **Or use Manual Tab** ⌨️
   - Enter any Registration ID (format: `ZNX2026-XXXXXX`)
   - Click "Verify & Check-In"

3. **See Stats** 📊
   - Go to Stats tab
   - Should show your activity

## 4️⃣ Deploy to Cloudflare Pages

See [CLOUDFLARE-DEPLOYMENT.md](./CLOUDFLARE-DEPLOYMENT.md) for detailed steps.

Quick version:
1. Update `BACKEND_URL` in `index.html`
2. Push to GitHub
3. Connect to Cloudflare Pages
4. Done! 🚀

## 5️⃣ Verification Checklist

- [ ] Backend is running (`npm start`)
- [ ] Can access http://localhost:8080/index.html
- [ ] Camera works (allow permission when prompted)
- [ ] Can enter test Registration ID
- [ ] Stats tab shows your activity
- [ ] Participant info displays when verified
- [ ] Check-In button works

## 6️⃣ Event Day Setup

**Before event starts:**

```bash
# Terminal 1: Backend
cd backend
npm start

# Terminal 2: Optional - If using local HTTP server
cd checkin
python -m http.server 8080
```

**During event:**
- Open: http://localhost:8080/index.html (local) OR
- Open: https://your-project.pages.dev (Cloudflare Pages)
- Start scanning QR codes
- Watch stats update in real-time

## 🎯 Usage Flow

1. **Scan** → Point camera at participant's QR code
2. **Verify** → System shows participant details
3. **Confirm** → Click "Check-In" button
4. **Done** → Status changes to "Already Checked In"

### Alternative Flow (Manual)
1. **Enter ID** → Type Registration ID manually
2. **Verify** → System looks up participant
3. **Check-In** → Click button to confirm
4. **Done** → Participant is checked-in

## 📊 Real-Time Stats

The Stats tab shows:
- **Total Scanned** - Verifications attempted
- **Checked In** - Successful check-ins  
- **Failed** - Not found / errors
- **Activity Log** - Last 20 with timestamps

Stats are saved locally (browser LocalStorage) but also update backend database.

## 🔧 If Something Breaks

### "Cannot reach backend"
```bash
# Make sure backend is running
cd backend
npm start
```

### "Camera error"
- Check browser permissions (Settings > Privacy > Camera)
- Allow camera access for localhost:8080

### "Registration not found"
- Check Registration ID format: `ZNX2026-XXXXXX`
- Verify it exists in database

### "CORS error in console"
- Update `BACKEND_URL` in checkin/index.html to match your backend
- Add your frontend URL to backend CORS origins

## 📱 Mobile Check-In Kiosk Setup

Perfect for event day kiosk:

```bash
# On the kiosk device
cd checkin
python -m http.server 8080 --bind 0.0.0.0
```

Then access from any device on network:
```
http://<kiosk-ip>:8080/index.html
```

Example: `http://192.168.1.100:8080/index.html`

---

**Ready to scan? Open → http://localhost:8080/index.html** ✅
