# Architecture Choice — Data Storage for a Food Delivery Startup

## Architecture Recommendation

For a fast-growing food delivery startup collecting GPS location logs, customer text reviews, payment transactions, and restaurant menu images, I recommend a **Data Lakehouse** architecture.

A traditional **Data Warehouse** is purpose-built for structured, relational data and excels at fast SQL analytics — but it cannot natively store raw GPS streams, free-text reviews, or binary image files without costly ETL pre-processing. This rigidity would force the startup to discard or heavily transform valuable raw data before storage, losing fidelity.

A pure **Data Lake** solves the format problem by storing all data in its raw form (JSON logs, image blobs, unstructured text), but it lacks schema enforcement, ACID transactions, and efficient query performance. As data volumes grow, a Data Lake tends to become a "data swamp" — hard to govern, slow to query, and unreliable for financial reporting.

A **Data Lakehouse** combines the best of both:

1. **Multi-format support in one system.** GPS logs (high-volume JSON/Parquet), text reviews (unstructured), payment records (structured), and menu images (binary) can all land in the same storage layer (e.g., Delta Lake or Apache Iceberg on object storage) without forcing a format compromise.

2. **ACID compliance for payment data.** Payment transactions require transactional guarantees — atomicity, consistency, isolation, durability. A Lakehouse (via Delta/Iceberg) provides these on top of cheap object storage, which a plain Data Lake cannot.

3. **Unified analytics and ML from a single source of truth.** The startup's data scientists can train delivery-time prediction models on GPS data, run sentiment analysis on reviews, and build recommendation engines on order history — all from the same platform, without duplicating data into a separate lake or warehouse. This eliminates data drift and reduces infrastructure costs significantly.

A Lakehouse therefore gives the startup the schema governance and query speed of a warehouse, the format flexibility of a lake, and a single platform that scales with both transactional and analytical workloads.
