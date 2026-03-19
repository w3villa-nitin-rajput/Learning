# Debugging Admin Category Creation & Image Upload Issues

## Overview of Issues Fixed

### 1. Admin Category Creation Failing in Production
**Root Cause**: JWT token validation or admin role not being properly checked  
**Potential Issues**:
- JWT secret mismatch between dev and production
- Token expiration
- User role not being properly transmitted in token
- Authorization check not returning proper feedback

### 2. Image Upload - Local Preview Not Persisting
**Root Cause**: Image not being properly saved to Cloudinary or returned to frontend  
**Potential Issues**:
- Cloudinary credentials not configured
- CORS issue with Cloudinary URLs
- Image URL not being returned properly
- Frontend not sending Cloudinary public ID to backend

---

## Debugging Steps

### Step 1: Check Application Health  

After Render deploys the latest changes, test these endpoints:

```bash
# Test 1: Basic health check (no auth required)
curl https://learning-pax0.onrender.com/debug/health

# Expected response:
{
  "status": "ok",
  "environment": "production",
  "timestamp": "2026-03-19T...",
  "solid_queue_in_puma": "true"
}
```

### Step 2: Debug JWT Authentication

```bash
# Get your admin's JWT token first (from login)
# Then use it here:

TOKEN="your_jwt_token_here"

# Test 2: Check authentication & token
curl -H "Authorization: Bearer $TOKEN" \
     https://learning-pax0.onrender.com/debug/auth

# Expected response:
{
  "current_user": {
    "id": 1,
    "email": "admin@example.com",
    "role": "admin",
    "is_admin": true,
    "authenticated": true
  },
  "token_decoded": {...},
  "authorization_header": "present"
}
```

**If this fails**, check:
- Token is valid (check `plan_expires_at` section below)
- `JWT_SECRET` is set in Render environment
- Token wasn't generated with a different secret

### Step 3: Test Admin Authorization

```bash
# Test 3: Verify admin access
curl -H "Authorization: Bearer $TOKEN" \
     https://learning-pax0.onrender.com/debug/admin

# Expected response:
{
  "message": "Admin access successful",
  "user": {
    "id": 1,
    "email": "admin@example.com",
    "role": "admin",
    "is_admin": true
  }
}
```

**If this fails with 403 (Forbidden)**:
- User is authenticated but NOT admin
- Check user's role in database: `UPDATE users SET role = 1 WHERE email = 'admin@example.com';`

**If this fails with 401 (Unauthorized)**:
- JWT token is invalid/expired
- Go to Step 2 to diagnose token issue

### Step 4: Test Category Creation (The Real Test)

```bash
# Test 4: Try creating a category
curl -X POST https://learning-pax0.onrender.com/categories \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "name": "Test Category",
      "path": "test-category",
      "image_url": "https://example.com/test.jpg",
      "bg_color": "#FF0000"
    }
  }'

# Expected response (201):
{
  "id": 123,
  "name": "Test Category",
  "path": "test-category",
  "image_url": "https://example.com/test.jpg",
  "bg_color": "#FF0000",
  "created_at": "...",
  "updated_at": "..."
}
```

**If this returns 403**:
- Admin auth is failing - go back to Step 3
- Check Render logs for `[ADMIN AUTH] ✗` messages

**If this returns 401**:
- User not authenticated - go back to Step 2
- Check Render logs for `[AUTHORIZATION ERROR]` messages

### Step 5: Debug Image Upload Configuration

```bash
# Test 5: Check Cloudinary config
curl -H "Authorization: Bearer $TOKEN" \
     https://learning-pax0.onrender.com/debug/image

# Expected response:
{
  "cloudinary_config": {
    "cloud_name": "your_cloud_name",
    "api_key_present": true,
    "api_secret_present": true
  },
  "user_image_data": {
    "cloudinary_url": "https://res.cloudinary.com/.../...",
    "cloudinary_public_id": "uploaded_file_id",
    "image_present": true
  },
  "cors_config": {
    "frontend_url": "https://your-frontend-domain.com",
    "allowed_origins": ["http://localhost:5173", "https://your-frontend-domain.com"]
  }
}
```

**If `api_key_present` or `api_secret_present` is false**:
- Set environment variables in Render:
  - `CLOUDINARY_CLOUD_NAME`
  - `CLOUDINARY_API_KEY`
  - `CLOUDINARY_API_SECRET`

**If `image_present` is false**:
- User hasn't uploaded an image yet
- Image not being saved to database after upload

---

## Checking Render Logs for Diagnostics

### Admin Auth Debug Messages

When an admin tries to create a category, look for:

**Success scenario:**
```
[AUTHORIZATION] Endpoint: /categories | Header present: true
[JWT] Decoding token...
[JWT] Token decoded successfully: user_id=1
[AUTHORIZATION] Looking up user_id: 1
[AUTHORIZATION] Found user: admin@example.com | Role: admin
[AUTHORIZATION] ✓ User authenticated: admin@example.com (admin)
[ADMIN AUTH] Checking admin access for user: 1
[ADMIN AUTH] @current_user.admin?: true
[ADMIN AUTH] ✓ Admin access granted for admin@example.com
```

**Failure scenario (not admin):**
```
[ADMIN AUTH] ✗ User is not admin (role: user)  <- User role is "user" instead of "admin"
```

**Failure scenario (not authenticated):**
```
[AUTHORIZATION ERROR] JWT decode error for /categories: ...
[ADMIN AUTH] ✗ User not authenticated
```

### Image Upload Debug Messages

When updating profile with image, look for:
```
[AUTHORIZATION] User authenticated successfully: user@example.com (user)
[Profile Updated] cloudinary_url: https://res.cloudinary.com/.../...
[Profile Updated] cloudinary_public_id: ...
```

---

## Common Issues & Solutions

### Issue: "Unauthorized: Admin access required" (403)

**Diagnostic**:
```bash
curl -H "Authorization: Bearer $TOKEN" https://learning-pax0.onrender.com/debug/admin
```

**Solutions**:
1. **Check if user is actually admin**:
   ```sql
   -- In Render's PostgreSQL dashboard
   SELECT id, email, role FROM users WHERE email = 'your-email@example.com';
   -- role should be: 1 (admin), not 0 (user)
   ```

2. **Update user role to admin**:
   ```sql
   UPDATE users SET role = 1 WHERE email = 'your-email@example.com';
   ```

### Issue: "Invalid or expired token" (401)

**Solutions**:
1. **Verify JWT_SECRET is set**:
   - Go to Render dashboard → Service → Environment
   - Confirm `JWT_SECRET` is set (should match your local `.env`)

2. **Check token expiration**:
   ```bash
   # Login again to get a fresh token
   curl -X POST https://learning-pax0.onrender.com/login \
     -H "Content-Type: application/json" \
     -d '{"email": "admin@example.com", "password": "your_password"}'
   ```

3. **Verify JWT secret matches**:
   - In Render, check that `JWT_SECRET` is the same as your local value
   - If not, update it and redeploy

### Issue: Image uploaded but not showing

**Solutions**:
1. **Check Cloudinary config**:
   ```bash
   curl -H "Authorization: Bearer $TOKEN" \
        https://learning-pax0.onrender.com/debug/image
   ```
   - Verify all `api_*_present` are `true`

2. **Check frontend CORS**:
   - Ensure frontend URL is in `FRONTEND_URL` environment variable
   - In Render: Settings → Environment → Add/Update `FRONTEND_URL`

3. **Check image actually saves**:
   ```bash
   curl -H "Authorization: Bearer $TOKEN" \
        https://learning-pax0.onrender.com/get-profile
   ```
   - Look for `cloudinary_url` in response
   - If empty, image isn't being saved

---

## Environment Variables Checklist

**Verify these are set in Render**:

| Variable | Required | Purpose |
|----------|----------|---------|
| `JWT_SECRET` | ✓ | Token encoding/decoding |
| `DATABASE_URL` | ✓ | Database connection |
| `RAILS_MASTER_KEY` | ✓ | Rails credentials |
| `CLOUDINARY_CLOUD_NAME` | ✓ | Image storage |
| `CLOUDINARY_API_KEY` | ✓ | Image upload access |
| `CLOUDINARY_API_SECRET` | ✓ | Image upload authentication |
| `FRONTEND_URL` | ✓ | CORS whitelist |
| `SOLID_QUEUE_IN_PUMA` | ✓ | Enable background jobs (set to "true") |

---

## Quick Test Script

Save this as `test_admin_and_images.sh`:

```bash
#!/bin/bash

API_URL="https://learning-pax0.onrender.com"
ADMIN_EMAIL="admin@example.com"
ADMIN_PASSWORD="your_password"

echo "🔍 Testing Admin Category Creation & Image Upload\n"

# Step 1: Health check
echo "1️⃣ Health Check..."
curl -s "$API_URL/debug/health" | jq .

# Step 2: Login
echo "\n2️⃣ Logging in..."
TOKEN=$(curl -s -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"$ADMIN_EMAIL\", \"password\": \"$ADMIN_PASSWORD\"}" | jq -r '.token')
echo "Token: ${TOKEN:0:20}..."

# Step 3: Auth check
echo "\n3️⃣ Checking authentication..."
curl -s -H "Authorization: Bearer $TOKEN" "$API_URL/debug/auth" | jq .

# Step 4: Admin check
echo "\n4️⃣ Checking admin access..."
curl -s -H "Authorization: Bearer $TOKEN" "$API_URL/debug/admin" | jq .

# Step 5: Image config
echo "\n5️⃣ Checking image/Cloudinary config..."
curl -s -H "Authorization: Bearer $TOKEN" "$API_URL/debug/image" | jq .

# Step 6: Create category
echo "\n6️⃣ Creating test category..."
curl -s -X POST "$API_URL/categories" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "name": "Debug Test",
      "path": "debug-test",
      "bg_color": "#FF0000"
    }
  }' | jq .

echo "\n✅ Tests Complete!"
```

Run with: `bash test_admin_and_images.sh`

---

## Next Steps

1. **Deploy** the latest code (already pushed)
2. **Test** each endpoint in order using the steps above
3. **Check Render logs** for the debug messages
4. **Share the log output** if issues persist

The enhanced logging will show exactly where the authorization is failing!
