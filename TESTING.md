# 🧪 Testing Guide - Check-In System

Complete testing procedures to verify the check-in system is working correctly.

## Pre-Test Checklist

- [ ] Backend server is running on port 5000
- [ ] MongoDB is connected
- [ ] You have test Registration IDs (format: `ZNX2026-XXXXXX`)
- [ ] Browser with camera for QR testing
- [ ] Internet connection (if testing remote backend)

## Test 1: Backend API Health

### Via Browser Console
```javascript
fetch('http://localhost:5000/api/checkin/stats')
  .then(r => r.json())
  .then(console.log)
```

**Expected Response**:
```json
{
  "total": 150,
  "checkedIn": 45,
  "pending": 105,
  "checkinPercentage": 30
}
```

### Via PowerShell (Windows)
```powershell
Invoke-WebRequest http://localhost:5000/api/checkin/stats | Select-Object -ExpandProperty Content
```

### Via curl (Mac/Linux)
```bash
curl http://localhost:5000/api/checkin/stats
```

**Status**: ✅ If you get valid JSON response

---

## Test 2: Verify Registration Endpoint

### Via Postman or Browser Console
```javascript
fetch('http://localhost:5000/api/checkin/verify', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({registrationId: 'ZNX2026-123456'})
})
.then(r => r.json())
.then(console.log)
```

**Expected Success Response**:
```json
{
  "msg": "Registration verified",
  "user": {
    "_id": "60f7b1a1b8c9d2e3f4g5h6i7",
    "fullName": "John Doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "college": "BITS Pilani",
    "category": "Student",
    "subCategory": ["Web Dev", "AI/ML"],
    "registrationId": "ZNX2026-123456",
    "checkedIn": false,
    "checkInTime": null
  }
}
```

**Expected Error Response** (if not found):
```json
{
  "msg": "Registration not found"
}
```

**Status**: ✅ If you get user data for valid registration

---

## Test 3: Check-In Participant Endpoint

### Via Browser Console
```javascript
// First, get a userId from verify endpoint
const verifyRes = await fetch('http://localhost:5000/api/checkin/verify', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({registrationId: 'ZNX2026-123456'})
});
const user = await verifyRes.json();

// Then check them in
const checkinRes = await fetch('http://localhost:5000/api/checkin/checkin', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    registrationId: 'ZNX2026-123456',
    userId: user.user._id
  })
});
console.log(await checkinRes.json());
```

**Expected Response**:
```json
{
  "msg": "Check-in successful",
  "user": {
    // ... user data ...
    "checkedIn": true,
    "checkInTime": "2026-03-07T10:30:45.123Z"
  },
  "checkedInAt": "2026-03-07T10:30:45.123Z"
}
```

**Status**: ✅ If `checkedIn` is true and timestamp is present

---

## Test 4: Frontend Application

### Manual Entry Test
1. Open: `http://localhost:8080/index.html`
2. Go to **Manual** tab
3. Enter: `ZNX2026-123456` (any valid ID)
4. Click: **Verify & Check-In**
5. **Expected**: Participant info displays

### Participant Info Verification
Once verified, you should see:
- ✅ Full name
- ✅ Email and mobile
- ✅ College name
- ✅ Category and activities
- ✅ Check-In status (Pending or Already Checked In)
- ✅ Pass type (if available)

### Check-In Action
1. Click: **✅ Check-In** button
2. Wait: Loading spinner appears briefly
3. **Expected**: 
   - Status changes to "Already Checked In"
   - Button disabled (greyed out)
   - Time stamp displayed

### Stats Tab
1. After multiple verifications, go to **Stats** tab
2. **Expected**:
   - Total Scanned: Has a number
   - Checked In: Count of successful check-ins
   - Failed: Count of not-found entries
   - Activity Log: Shows recent entries

---

## Test 5: QR Code Scanning

### Generate Test QR Code
Create a QR code containing a registration ID:

**Using online tool:**
1. Go to [qr-server.com](https://qr-server.com/qr-code/)
2. Enter: `ZNX2026-123456`
3. Generate and print/display

### Test Scanner
1. Open: `http://localhost:8080/index.html`
2. Go to **Scanner** tab
3. Click: **🎥 Start Scanner**
4. **Allow: Camera permission** when prompted
5. Point camera at QR code
6. **Expected**: Automatic detection within 2 seconds

### Scanner Behavior
- Video stream shows
- No errors in console
- Participant info appears after detection
- Can check-in if not already

---

## Test 6: Browser Compatibility

| Browser | Desktop | Mobile | Notes |
|---------|---------|--------|-------|
| Chrome | ✅ Full | ✅ Full | Best support |
| Firefox | ✅ Full | ✅ Full | Good support |
| Safari | ✅ Full | ⚠️ Limited | Camera works, check iOS version |
| Edge | ✅ Full | ✅ Full | Full support |

### Test Steps for Each Browser
1. Open `http://localhost:8080/index.html`
2. Grant camera permission
3. Test both manual entry and camera
4. Check Stats tab
5. Verify no console errors (F12 > Console)

---

## Test 7: Error Scenarios

### Scenario 1: Invalid Registration ID
**Input**: `INVALID-12345`

**Expected**:
- Alert: "❌ Registration not found"
- Participant info hidden
- Stats updated with failure count

### Scenario 2: Already Checked-In Participant
**Input**: Registration ID of someone already checked-in

**Expected**:
- Status badge shows: ✅
- Status text: "Already Checked In"
- Check-In button disabled
- Cannot check-in again

### Scenario 3: Backend Down
**Setup**: Stop backend server

**Expected**:
- Alert: "Connection error: ..."
- Participant info hidden
- No console errors (graceful failure)

### Scenario 4: Wrong CORS Configuration
**Setup**: Update backend URL to wrong domain in index.html

**Expected**:
- Browser console shows CORS error
- Alert: "Connection error"
- Network tab (F12) shows failed CORS request

### Scenario 5: Camera Permission Denied
**Setup**: Deny camera permission when prompted

**Expected**:
- Alert: "Camera error: Permission denied"
- Fallback to Manual tab works fine
- Can still check-in with manual ID entry

---

## Test 8: Performance Testing

### Load Testing Frontend
1. Open Browser DevTools (F12)
2. Go to **Performance** tab
3. Start recording
4. Quick actions:
   - Verify 3 participants
   - Check-in each one
   - Switch tabs 5 times
5. Stop recording

**Expected Metrics**:
- First Contentful Paint: < 2s
- Pages loads without jank
- Stats update smoothly

### API Response Time
```javascript
// Test in browser console
console.time('verify');
await fetch('http://localhost:5000/api/checkin/verify', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({registrationId: 'ZNX2026-123456'})
});
console.timeEnd('verify');
```

**Expected**: < 200ms response time

---

## Test 9: LocalStorage Persistence

1. Open check-in app
2. Verify 2 participants
3. Check Stats tab (should show count)
4. **Refresh page** (Ctrl+R)
5. Go back to Stats tab

**Expected**: Stats are still there! (preserved in browser storage)

---

## Test 10: Production Deployment

### Pre-Deployment
- [ ] Backend URL updated in index.html
- [ ] Backend CORS includes Cloudflare Pages URL
- [ ] All tests 1-9 passing
- [ ] No console errors

### Deployment Test
1. Deploy to Cloudflare Pages
2. Access: `https://your-project.pages.dev/index.html`
3. Run Tests 2, 3, 4, 5 again on production

**Expected**: Same results as local testing

---

## Debugging Tips

### Enable Verbose Logging
Add to browser console:
```javascript
// Log all API calls
const originalFetch = fetch;
window.fetch = function(...args) {
  console.log('API Call:', args);
  return originalFetch.apply(this, args)
    .then(r => {
      console.log('Response:', r.status);
      return r;
    });
};
```

### Monitor Network Requests
1. Open DevTools (F12)
2. Go to **Network** tab
3. Perform actions
4. Click on requests to see:
   - Request headers
   - Request body
   - Response status
   - Response data

### Check Console for Errors
**F12 > Console tab** shows all errors/warnings

Common messages:
- ✅ "Backend URL: http://localhost:5000" - Good
- ⚠️ "Cannot reach backend" - Backend not running
- ❌ CORS error - CORS not configured

---

## Success Criteria

| Metric | Passing | Failing |
|--------|---------|---------|
| API responds to health check | ✅ Yes | ❌ No |
| Can verify valid registration | ✅ Yes | ❌ No |
| Can check-in participant | ✅ Yes | ❌ No |
| QR scanner detects codes | ✅ Yes | ❌ Timeouts |
| Stats persist on page refresh | ✅ Yes | ❌ Reset |
| Manual entry works | ✅ Yes | ❌ Errors |
| No console errors | ✅ None | ❌ Errors present |
| Works on mobile camera | ✅ Yes | ❌ Fails |

## Test Completion Checklist

- [ ] All 10 tests completed
- [ ] All success criteria met
- [ ] No console errors
- [ ] Deployed successfully
- [ ] Event staff trained on system
- [ ] Backup check-in method ready

---

**Ready for Event Day!** ✅
