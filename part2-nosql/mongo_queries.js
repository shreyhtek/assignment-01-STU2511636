// Select (or create) the working database
use("ecommerce_catalog");
 
// Reference the products collection
const products = db.getCollection("products");
 
 
// -------------------------------------------------------------
// OP1: insertMany() — insert all 3 documents from sample_documents.json
//
// Inserts one document per product category (Electronics,
// Clothing, Groceries) with all their category-specific fields.
// ordered:false means a single failure won't abort the rest.
// -------------------------------------------------------------
products.insertMany(
  [
    {
      _id: "prod_elec_001",
      category: "Electronics",
      name: "Samsung Galaxy Book3 Pro",
      brand: "Samsung",
      sku: "SGB3P-16-512-SLV",
      price: 89990,
      currency: "INR",
      stock: 34,
      specs: {
        display: {
          size_inches: 16,
          resolution: "2880x1800",
          panel_type: "AMOLED",
          refresh_rate_hz: 120
        },
        processor: {
          brand: "Intel",
          model: "Core i7-1360P",
          cores: 12,
          base_ghz: 2.2,
          boost_ghz: 5.0
        },
        memory_gb: 16,
        storage_gb: 512,
        storage_type: "NVMe SSD",
        battery_wh: 76,
        weight_kg: 1.56,
        voltage: {
          input: "100-240V",
          frequency_hz: "50/60Hz"
        },
        ports: ["USB-C (Thunderbolt 4)", "USB-C 3.2", "USB-A 3.2", "HDMI 2.0", "microSD", "3.5mm audio"],
        wireless: ["Wi-Fi 6E", "Bluetooth 5.3"]
      },
      warranty: {
        duration_months: 12,
        type: "Manufacturer",
        coverage: ["manufacturing defects", "hardware failure"],
        excludes: ["physical damage", "liquid damage"],
        support_contact: "1800-40-Samsung"
      },
      certifications: ["BIS", "ISI", "RoHS"],
      in_box: ["Laptop", "65W USB-C Adapter", "Quick Start Guide"],
      tags: ["laptop", "ultrabook", "work", "amoled"],
      created_at: new Date("2024-03-01T10:00:00Z"),
      updated_at: new Date("2024-11-15T08:30:00Z")
    },
    {
      _id: "prod_clth_001",
      category: "Clothing",
      name: "Men's Slim Fit Oxford Shirt",
      brand: "Arrow",
      sku: "ARW-OXFRD-SLM-NVY-L",
      price: 1799,
      currency: "INR",
      stock: 120,
      variants: [
        { size: "S",  color: "Navy Blue", color_hex: "#1B2A6B", stock: 22, sku_variant: "ARW-OXFRD-SLM-NVY-S"  },
        { size: "M",  color: "Navy Blue", color_hex: "#1B2A6B", stock: 38, sku_variant: "ARW-OXFRD-SLM-NVY-M"  },
        { size: "L",  color: "Navy Blue", color_hex: "#1B2A6B", stock: 35, sku_variant: "ARW-OXFRD-SLM-NVY-L"  },
        { size: "XL", color: "Navy Blue", color_hex: "#1B2A6B", stock: 25, sku_variant: "ARW-OXFRD-SLM-NVY-XL" }
      ],
      fabric: {
        composition: [
          { material: "Cotton",    percent: 80 },
          { material: "Polyester", percent: 20 }
        ],
        weight_gsm: 130,
        weave: "Oxford",
        finish: "Wrinkle-resistant"
      },
      fit: "Slim Fit",
      occasion: ["Formal", "Business Casual"],
      care_instructions: [
        "Machine wash cold",
        "Do not bleach",
        "Tumble dry low",
        "Iron on medium heat",
        "Do not dry clean"
      ],
      country_of_origin: "India",
      sizes_available: ["S", "M", "L", "XL", "XXL"],
      sustainable: false,
      tags: ["shirt", "formal", "cotton", "slim-fit", "office-wear"],
      created_at: new Date("2024-01-10T09:00:00Z"),
      updated_at: new Date("2024-10-05T14:20:00Z")
    },
    {
      _id: "prod_groc_001",
      category: "Groceries",
      name: "Organic Rolled Oats",
      brand: "True Elements",
      sku: "TE-ORG-OATS-1KG",
      price: 349,
      currency: "INR",
      stock: 280,
      weight: { net_grams: 1000, gross_grams: 1080 },
      dates: {
        manufactured: new Date("2024-09-01"),
        best_before:  new Date("2025-08-31"),
        expiry:       new Date("2025-12-31")
      },
      storage: "Store in a cool, dry place. Keep away from direct sunlight. Once opened, seal tightly.",
      nutritional_info: {
        serving_size_g:    40,
        servings_per_pack: 25,
        per_serving: {
          calories_kcal:         148,
          protein_g:               5.2,
          carbohydrates_g:        25.0,
          of_which_sugars_g:       0.5,
          dietary_fibre_g:         3.8,
          fat_g:                   2.8,
          of_which_saturated_g:    0.5,
          sodium_mg:               2
        }
      },
      ingredients: ["Whole Grain Rolled Oats (100%)"],
      allergens: ["Gluten"],
      allergen_free_from: ["Dairy", "Soy", "Nuts", "Eggs"],
      certifications: [
        { name: "USDA Organic",    cert_number: "USDA-ORG-2024-4421" },
        { name: "FSSAI Licensed",  cert_number: "10019022007399"     }
      ],
      diet_tags: ["Vegan", "Gluten-Containing", "High-Fibre", "Organic"],
      country_of_origin: "India",
      tags: ["oats", "breakfast", "organic", "healthy", "high-protein"],
      created_at: new Date("2024-09-05T07:00:00Z"),
      updated_at: new Date("2024-09-05T07:00:00Z")
    }
  ],
  { ordered: false }
);
 
 
// -------------------------------------------------------------
// OP2: find() — retrieve all Electronics products with price > 20000
//
// Filters on two fields simultaneously.
// Projection excludes internal fields (_id, timestamps) for
// a cleaner result — set to 1 to include, 0 to exclude.
// -------------------------------------------------------------
products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  {
    _id:      0,
    name:     1,
    brand:    1,
    price:    1,
    currency: 1,
    stock:    1,
    warranty: 1
  }
);
 
 
// -------------------------------------------------------------
// OP3: find() — retrieve all Groceries expiring before 2025-01-01
//
// Queries a nested date field using dot notation.
// Products whose expiry date is before Jan 1 2025 need urgent
// attention (discounting, removal, or recall).
// -------------------------------------------------------------
products.find(
  {
    category:      "Groceries",
    "dates.expiry": { $lt: new Date("2025-01-01") }
  },
  {
    _id:           0,
    name:          1,
    brand:         1,
    price:         1,
    "dates.expiry": 1,
    stock:         1
  }
);
 
 
// -------------------------------------------------------------
// OP4: updateOne() — add a "discount_percent" field to a specific product
//
// Targets the Electronics laptop by its _id and uses $set to
// add/overwrite a single field without touching any other data.
// A second $set key updates the timestamp to reflect the change.
// -------------------------------------------------------------
products.updateOne(
  { _id: "prod_elec_001" },
  {
    $set: {
      discount_percent: 10,
      updated_at: new Date()
    }
  }
);
 
// Verify the update
products.findOne(
  { _id: "prod_elec_001" },
  { name: 1, price: 1, discount_percent: 1, updated_at: 1 }
);
 
 
// -------------------------------------------------------------
// OP5: createIndex() — create an index on the category field
//
// WHY THIS INDEX?
// Nearly every query in this catalog filters by category first
// (e.g., "all Electronics over ₹20,000", "all Groceries expiring
// soon"). Without an index, MongoDB performs a full collection
// scan (COLLSCAN) on every such query — O(n) regardless of how
// many documents match.
//
// With this ascending index on `category`, MongoDB uses an
// index scan (IXSCAN), jumping directly to the matching bucket
// of documents. For a catalog with hundreds of thousands of
// products, this cuts query time from seconds to milliseconds.
//
// background:true (deprecated in MongoDB 4.2+, kept for older
// compatibility) builds the index without blocking reads/writes.
// Use commitQuorum in replica-set environments instead.
// -------------------------------------------------------------
products.createIndex(
  { category: 1 },
  {
    name:       "idx_category_asc",
    background: true          // non-blocking on MongoDB < 4.2
  }
);
 
// Confirm the index was created
products.getIndexes();
 
// Demonstrate the index is actually used (look for "IXSCAN" in winningPlan)
products.find({ category: "Electronics" }).explain("executionStats");
 