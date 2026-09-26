# Frontend ↔ Backend CRUD mapping

The admin frontend now uses the actual NestJS controller routes from the supplied Backend project.

- Shops: GET/POST `/shops`, PUT/DELETE `/shops/:id`
- Groomers: GET/POST `/groomers`, PUT/DELETE `/groomers/:id`
- Banners: GET/POST `/banners`, PUT/DELETE `/banners/:id`
- Products: GET/POST `/products`, PUT/DELETE `/products/:id`
- Services: GET/POST `/services`, PUT/DELETE `/services/:id`
- Appointments: GET/POST `/appointments`, PUT/DELETE `/appointments/:id`
- Users: GET/POST `/users`, PUT/DELETE `/users/:id`
- Pets: GET/POST `/pets`, PUT/DELETE `/pets/:id`
- Shop Orders: GET/POST `/shop-orders`, PUT/DELETE `/shop-orders/:id`

Forms are based on the supplied Create/Update DTOs. Numeric values are converted before submission; appointment servicePriceIds accepts comma-separated IDs; order products accepts JSON and is converted to the nested products array expected by CreateShopOrderDto.

Backend DTO field naming was normalized to camelCase for update operations so it matches the generated ORM fields and create DTOs (Banner, User, ShopOrder updates). User update balance validation was corrected to integer validation.
