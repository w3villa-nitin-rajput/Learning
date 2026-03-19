# Solid Queue Recurring Jobs Fix for Render

## Issues Identified & Fixed

### 1. **Queue Database Migrations Not Running** ✅ FIXED
**Problem:** Only the primary database was being migrated. The queue, cache, and cable databases need separate migrations.

**Solution:** Updated two files to use `db:prepare` instead of `db:migrate`:
- `bin/docker-entrypoint` - now runs `./bin/rails db:prepare`
- `bin/render-build.sh` - now runs `bundle exec rails db:prepare`

`db:prepare` automatically runs migrations for ALL configured databases (primary, cache, queue, cable).

### 2. **Solid Queue Scheduler Not Running** ✅ FIXED
**Problem:** The Solid Queue recurring job scheduler wasn't active in production. Solid Queue needs either:
- A separate worker process running `bin/jobs`, OR
- The scheduler embedded in Puma process via `SOLID_QUEUE_IN_PUMA=true`

**Solution:** Updated `Dockerfile` to enable Solid Queue inside Puma:
```dockerfile
ENV SOLID_QUEUE_IN_PUMA="true"
```

This allows the job scheduler to run within the web process without needing a separate worker dyno.

### 3. **Improved Job Logging** ✅ FIXED
**Problem:** The original job had minimal logging, making it hard to debug in production.

**Solution:** Enhanced `app/jobs/expire_plans_job.rb` with:
- Better timestamp logging (uses `Time.current` instead of `Time.now`)
- Count of expired users found
- Individual user update logs with email for verification
- Comprehensive error handling with backtrace logging

### 4. **Recurring Job Configuration Enhanced** ✅ FIXED
**Problem:** Minimal configuration without explanations.

**Solution:** Updated `config/recurring.yml` with:
- Added queue specification for better control
- Added detailed comments explaining the schedule format
- Clear documentation of what each job does

## What You Need to Do on Render

### Step 1: Redeploy Your Application
Push your changes to your repository and trigger a new deployment on Render:
```bash
git add -A
git commit -m "Fix Solid Queue recurring jobs for production"
git push
```

Render will:
1. Run `bin/render-build.sh` (now runs `db:prepare` for all databases)
2. Build the Docker image with `SOLID_QUEUE_IN_PUMA=true`
3. Execute `bin/docker-entrypoint` on startup (runs `db:prepare` again to ensure migrations)

### Step 2: Verify the Fix

Check Render logs for these indicators of success:

1. **During build:**
```
Running migrations for all databases...
-- create_table("solid_queue_jobs", ...)
-- create_table("solid_queue_executions", ...)
```

2. **During startup:**
```
=== ExpirePlansJob started at [timestamp] ===
Found X users with expired plans
Updated user YYY (email@example.com): silver -> free
=== ExpirePlansJob completed successfully ===
```

If you see these messages repeating every minute, your recurring job is working! ✅

### Step 3: Monitor the Logs

Go to your Render dashboard and watch the logs in real-time:
- Look for "ExpirePlansJob started" messages
- Look for "Found X users with expired plans"
- Any errors will show with full backtrace

## Why This Works

1. **`db:prepare`** - Automatically handles all databases configured in `database.yml`:
   - Primary (main app data)
   - Cache (solid_cache tables)
   - Queue (solid_queue tables - needed for recurring jobs!)
   - Cable (solid_cable tables)

2. **`SOLID_QUEUE_IN_PUMA=true`** - Embeds the job scheduler in Puma:
   - No separate worker dyno needed
   - Scheduler runs in the same process as the web server
   - Recurring jobs are loaded from `config/recurring.yml` automatically
   - Jobs execute on the specified schedule

3. **Enhanced logging** - Makes debugging easier:
   - Clear visibility into when jobs run
   - Count of affected users
   - Individual records logged for verification
   - Error details captured

## Alternative: Separate Worker Process (Better for Production)

For a more robust production setup, you could create a separate Render service for background jobs:

1. Create a new "Background Worker" service on Render
2. Use the same Docker image
3. Override the startup command to:
```bash
./bin/rails db:prepare && ./bin/jobs
```
4. Set `JOB_CONCURRENCY=1` or higher based on your needs

This approach is recommended if you have:
- High volume of background jobs
- Long-running jobs that might block the web process
- Need for independent scaling

## Troubleshooting

If recurring jobs still don't work after redeployment:

1. **Check environment variables** in Render dashboard
   - Ensure no `SOLID_QUEUE_IN_PUMA` override is set to false

2. **Check database migrations ran**
   - Look for "solid_queue_jobs" table in your PostgreSQL database
   - Use Render's PostgreSQL dashboard

3. **Check job logs**
   - Filter logs for "ExpirePlansJob"
   - Look for any database connection errors

4. **Verify recurring.yml syntax**
   - YAML must be properly formatted
   - Check `config/recurring.yml` is committed to git

5. **Manually test the job**
   - In Render's web shell or local dev: `./bin/rails expire_plans:perform`
   - Or: `./bin/rails runner 'ExpirePlansJob.new.perform'`

## Files Modified

- ✅ `bin/docker-entrypoint` - Use `db:prepare` for all databases
- ✅ `bin/render-build.sh` - Use `db:prepare` for all databases  
- ✅ `Dockerfile` - Enable `SOLID_QUEUE_IN_PUMA=true`
- ✅ `app/jobs/expire_plans_job.rb` - Improved logging and error handling
- ✅ `config/recurring.yml` - Enhanced configuration with comments

## Testing Locally (Optional)

To verify your fix works before pushing:

```bash
# Start the development server with job scheduler
SOLID_QUEUE_IN_PUMA=true bundle exec rails server

# In another terminal, trigger the job immediately
./bin/rails runner 'ExpirePlansJob.new.perform'

# Watch the logs for the success messages
```

---

**Your subscription expiration checker should now work reliably in production! 🚀**
