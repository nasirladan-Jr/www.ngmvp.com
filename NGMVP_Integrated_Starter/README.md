# NGMVP Integrated Starter — The Next Generation Movement Vote Protection

This is a Next.js + Supabase starter for a professional NGMVP vote-protection/civic-observation site. It is designed to sit beside the existing NGM membership platform without replacing membership registration, cards, or member records.

## What's included
- Responsive NGMVP landing page and pages for vote protection, incident reporting, observer interest, privacy, and NGM connection.
- Incident-report and observer-interest forms wired to Supabase.
- Separate `ngmvp_*` database tables and row-level security (RLS) policies. Anonymous visitors can insert submissions but cannot list or read other people's submissions.
- Header/footer link to the existing NGM website via `NEXT_PUBLIC_NGM_SITE_URL`.
- Nigerian election categories: presidential, governorship, senatorial, House of Representatives.

## 1. Install on your laptop
Install Node.js LTS from https://nodejs.org/ and use Terminal:

```bash
unzip NGMVP_Integrated_Starter.zip
cd NGMVP_Integrated_Starter
npm install
cp .env.example .env.local
```

Open `.env.local` and add your existing Supabase project's **Project URL** and **anon/public key**. Add the public URL of the current NGM website in `NEXT_PUBLIC_NGM_SITE_URL`. Never use a service-role key in a browser app.

## 2. Connect to your existing Supabase project
1. Open the same Supabase project used by your NGM membership platform.
2. Go to **SQL Editor → New query**.
3. Paste and run the contents of `supabase/schema.sql`.
4. Confirm both `ngmvp_incident_reports` and `ngmvp_observer_applications` exist under Table Editor.
5. Check RLS is enabled. Test that public users can submit but cannot select/read records.

The NGMVP tables are deliberately separate from the existing NGM membership tables. Do not rename, delete, or overwrite your membership tables. The existing membership sign-up/auth/card workflow can remain in place; if both sites use the same Supabase project and auth configuration, a signed-in user session may be shared only when the domain/cookie setup supports it. Separate subdomains often require explicit auth redirect/cookie planning.

## 3. Run locally

```bash
npm run dev
```

Open http://localhost:3000. Try `/report`, `/observer`, `/vote-protection`, and `/movement`.

## 4. Deploy
1. Push this folder to a private GitHub repository.
2. Import it into Vercel.
3. Add the same three environment variables from `.env.local` in Vercel project settings.
4. Deploy, then configure the Supabase Auth URL allow-list if you later add authenticated observer/reviewer areas.
5. Point a subdomain such as `vote.your-ngm-domain.ng` to this app, or merge these routes into the existing NGM Next.js app for one shared domain.

## Integration choices
**Recommended first launch:** keep the main NGM website as the organisation/membership home and link its navigation to NGMVP, hosted as a subdomain such as `vote.example.org`. This gives the project a distinct identity while preserving the main membership platform. For the most seamless single-site experience, merge these `src/app` routes and `src/lib/supabase.ts` into the existing NGM Next.js repository rather than deploying two unrelated apps.

Replace `https://example.org` in `src/app/layout.tsx` metadata with your real public domain before production.

## Important production work still required
- Build an authenticated, role-restricted reviewer/admin dashboard. The starter intentionally has no public report feed and no reviewer read policy.
- Add server-side rate limiting, bot/spam protection, input moderation, abuse monitoring, backups and a data-retention/deletion process.
- Restrict access to reports/contact details to trained authorised staff, enable MFA, and document escalation procedures.
- Publish the organisation's privacy notice and obtain legal/privacy review for Nigerian data-protection obligations.
- Do not present reports as official INEC results, claim verification without review, or collect NIN/voter-card numbers through these forms.
- Confirm current INEC rules and official observer accreditation requirements before operating in the field. This website does not itself accredit observers or replace lawful official reporting channels.

## Troubleshooting
- `Invalid API key`: use the Supabase anon/public key from Project Settings → API, not the service-role key.
- `relation does not exist`: run `supabase/schema.sql` in the correct project.
- `row-level security policy violation`: check RLS is enabled and the insert policies exist exactly as in the SQL file.
- Form says env vars missing: ensure `.env.local` is at the project root and restart `npm run dev`.
