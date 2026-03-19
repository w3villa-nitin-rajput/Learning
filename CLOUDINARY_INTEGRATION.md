# Cloudinary Integration for Products & Categories

## Overview

Both **Products** and **Categories** now support Cloudinary image uploads, allowing admins to upload and manage images efficiently.

## Database Changes

Two new columns have been added to both tables:
- `cloudinary_url` - The full URL to the image on Cloudinary
- `cloudinary_public_id` - The public ID for the image (used for deletion and updates)

### Migration
File: `db/migrate/20260319120000_add_cloudinary_fields_to_products_and_categories.rb`

**Before deploying to production, run:**
```bash
bundle exec rails db:migrate
```

---

## How to Use

### 1. Getting a Cloudinary Signature

Before uploading an image, request a signature from the backend:

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-api.com/cloudinary/signature
```

Response:
```json
{
  "signature": "...",
  "timestamp": 1711000000,
  "cloud_name": "your_cloud_name",
  "api_key": "your_api_key"
}
```

### 2. Upload Image to Cloudinary

Use the signature to upload directly from frontend to Cloudinary:

```javascript
// Frontend example (using axios)
const formData = new FormData();
formData.append('file', imageFile);
formData.append('upload_preset', 'your_upload_preset'); // Optional
formData.append('signature', signatureResponse.signature);
formData.append('timestamp', signatureResponse.timestamp);
formData.append('api_key', signatureResponse.api_key);

const uploadResponse = await axios.post(
  `https://api.cloudinary.com/v1_1/${signatureResponse.cloud_name}/image/upload`,
  formData
);

const { secure_url, public_id } = uploadResponse.data;
```

### 3. Create/Update Product with Image

#### Create Product with Image:

```bash
curl -X POST https://your-api.com/products \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "name": "Product Name",
      "category": "Electronics",
      "price": 99.99,
      "offer_price": 79.99,
      "in_stock": true,
      "cloudinary_url": "https://res.cloudinary.com/.../image.jpg",
      "cloudinary_public_id": "products/image_xyz123"
    }
  }'
```

Response:
```json
{
  "id": 1,
  "name": "Product Name",
  "cloudinary_url": "https://res.cloudinary.com/.../image.jpg",
  "cloudinary_public_id": "products/image_xyz123",
  "...other fields"
}
```

#### Update Product Image:

```bash
curl -X PUT https://your-api.com/products/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "cloudinary_url": "https://res.cloudinary.com/.../new_image.jpg",
      "cloudinary_public_id": "products/new_image_abc456"
    }
  }'
```

**Note:** The old image (if it exists) is automatically deleted from Cloudinary when updating with a new public ID.

### 4. Create/Update Category with Image

#### Create Category with Image:

```bash
curl -X POST https://your-api.com/categories \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "name": "Electronics",
      "path": "electronics",
      "bg_color": "#FF0000",
      "cloudinary_url": "https://res.cloudinary.com/.../category.jpg",
      "cloudinary_public_id": "categories/electronics_xyz"
    }
  }'
```

#### Update Category Image:

```bash
curl -X PUT https://your-api.com/categories/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "cloudinary_url": "https://res.cloudinary.com/.../new_category.jpg",
      "cloudinary_public_id": "categories/new_electronics_abc"
    }
  }'
```

### 5. Get Products and Categories with Images

#### Get All Products:

```bash
curl https://your-api.com/products | jq
```

Response includes:
```json
{
  "products": [
    {
      "id": 1,
      "name": "Product Name",
      "cloudinary_url": "https://res.cloudinary.com/.../image.jpg",
      "cloudinary_public_id": "products/image_xyz123",
      "...other fields"
    }
  ]
}
```

#### Get All Categories:

```bash
curl https://your-api.com/categories | jq
```

Response includes:
```json
[
  {
    "id": 1,
    "name": "Electronics",
    "cloudinary_url": "https://res.cloudinary.com/.../category.jpg",
    "cloudinary_public_id": "categories/electronics_xyz",
    "...other fields"
  }
]
```

---

## Image Deletion

Images are automatically deleted from Cloudinary when:

1. **Updating with new image**: Old image deleted when new `cloudinary_public_id` is provided
2. **Destroying product/category**: Image automatically deleted from Cloudinary

Example logs:
```
Deleted Cloudinary image: products/image_xyz123
```

---

## API Endpoints Summary

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| GET | `/cloudinary/signature` | ✓ Admin | Get upload signature |
| GET | `/products` | ✗ | List all products |
| GET | `/products/:id` | ✗ | Get product details |
| POST | `/products` | ✓ Admin | Create product with image |
| PUT | `/products/:id` | ✓ Admin | Update product/image |
| DELETE | `/products/:id` | ✓ Admin | Delete product & image |
| GET | `/categories` | ✗ | List all categories |
| POST | `/categories` | ✓ Admin | Create category with image |
| PUT | `/categories/:id` | ✓ Admin | Update category/image |
| DELETE | `/categories/:id` | ✓ Admin | Delete category & image |

---

## Complete Frontend Example

```javascript
// 1. Get upload signature
async function getCloudinarySignature(token) {
  const response = await fetch('/cloudinary/signature', {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  return await response.json();
}

// 2. Upload image to Cloudinary
async function uploadToCloudinary(file, signatureData) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('signature', signatureData.signature);
  formData.append('timestamp', signatureData.timestamp);
  formData.append('api_key', signatureData.api_key);
  
  const response = await fetch(
    `https://api.cloudinary.com/v1_1/${signatureData.cloud_name}/image/upload`,
    { method: 'POST', body: formData }
  );
  
  const data = await response.json();
  return {
    cloudinary_url: data.secure_url,
    cloudinary_public_id: data.public_id
  };
}

// 3. Create/Update product with image
async function createProduct(productData, token) {
  const response = await fetch('/products', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ product: productData })
  });
  
  return await response.json();
}

// 4. Usage example
async function handleProductWithImage(file, productInfo, token) {
  // Step 1: Get signature
  const signature = await getCloudinarySignature(token);
  
  // Step 2: Upload image
  const imageData = await uploadToCloudinary(file, signature);
  
  // Step 3: Create product with image
  const completeProduct = {
    ...productInfo,
    ...imageData
  };
  
  const createdProduct = await createProduct(completeProduct, token);
  console.log('Product created:', createdProduct);
}
```

---

## Troubleshooting

### Images not showing in responses
- Verify `CLOUDINARY_CLOUD_NAME` is set in environment
- Confirm `cloudinary_url` field is populated in database
- Check CORS configuration allows Cloudinary domain

### Old images not being deleted
- Verify `CLOUDINARY_API_SECRET` is set correctly
- Check Render logs for deletion error messages
- Confirm `cloudinary_public_id` field exists and has value

### Upload signature not working
- Verify user is authenticated (check `/debug/auth` endpoint)
- Confirm `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET` are all set
- Check Render logs for JWT validation errors

### 403 Forbidden when creating/updating
- User must be admin (role = 1)
- Check `/debug/admin` endpoint
- Verify JWT token is valid and not expired

---

## Testing

### Test with curl

```bash
# 1. Login as admin
TOKEN=$(curl -s -X POST https://your-api.com/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password"}' | jq -r '.token')

# 2. Get signature
curl -H "Authorization: Bearer $TOKEN" \
     https://your-api.com/cloudinary/signature | jq

# 3. Create product with image
curl -X POST https://your-api.com/products \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "name": "Test Product",
      "category": "Test",
      "price": 99.99,
      "cloudinary_url": "https://res.cloudinary.com/demo/image/upload/v1234567/sample",
      "cloudinary_public_id": "sample"
    }
  }' | jq

# 4. Get all products with images
curl https://your-api.com/products | jq '.products[0] | {name, cloudinary_url, cloudinary_public_id}'
```

---

## Environment Variables Required

Ensure these are set in Render:
- `CLOUDINARY_CLOUD_NAME` - Your Cloudinary cloud name
- `CLOUDINARY_API_KEY` - Your Cloudinary API key
- `CLOUDINARY_API_SECRET` - Your Cloudinary API secret (for deletion)

---

## Model Methods

Both `Product` and `Category` models have:

```ruby
def delete_old_cloudinary_image
  # Automatically called when updating with new image
  # Or manually call: product.delete_old_cloudinary_image
end
```

Example:
```ruby
product = Product.find(1)
product.delete_old_cloudinary_image  # Manually delete old image
```

---

## Next Steps

1. **Deploy** to Render with `git push`
2. **Run migrations** on Render (automatic on deploy)
3. **Test** with the curl examples above
4. **Monitor** logs for any image upload/deletion issues
5. **Use** the frontend example to implement UI

The integration is now complete! 🚀
