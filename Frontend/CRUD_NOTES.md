# CRUD implementation notes

The admin UI now uses `src/api.js` as the single Axios client. It automatically adds the stored bearer token and reads the API base URL from `VITE_API_URL`.

## REST convention used

For each management resource configured in `MainPage.jsx`:

- Read: `GET /resource`
- Create: `POST /resource`
- Update: `PATCH /resource/:id`
- Delete: `DELETE /resource/:id`
- Batch delete: sends `DELETE /resource/:id` for each selected id and reports partial failures.

Additional existing/special actions:

- Reset password: `POST /resource/:id/reset-password`
- Activate: `PATCH /resource/:id` with `{ activation_status: 1 }`
- Process order: `POST /shop-orders/process/:id`

If the backend uses different routes or DTO field names, update the endpoint/field mapping in `src/components/MainPage.jsx`; the UI CRUD flow does not need to be rewritten.

## UI changes

- Create modal
- Edit modal pre-filled from the selected row
- Single delete with confirmation
- Real batch delete against the API
- Loading, success and API error feedback
- Token-aware API client
- `VITE_API_URL` environment configuration

## Install / run

Do not reuse `node_modules` copied from another OS. Run:

```bash
npm install
npm run dev
```

Then verify each endpoint against the backend API contract before production deployment.
