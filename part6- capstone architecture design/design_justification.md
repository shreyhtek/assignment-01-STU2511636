# Part 6 — Capstone Architecture Design

## Storage Systems

The architecture uses five purpose-built storage systems, each matched to a specific goal.

**Goal 1 — Predict patient readmission risk** is served by **PostgreSQL** (OLTP) and **InfluxDB** (time-series). PostgreSQL stores the structured historical treatment data — diagnoses, medications, discharge records, lab results — that feeds the ML feature pipeline. InfluxDB stores time-stamped ICU vitals history, which is essential for deriving temporal features (e.g. heart rate trend over 48 hours) used by the readmission model. Together they give the ML pipeline both static and time-varying patient signals.

**Goal 2 — Allow doctors to query patient history in plain English** is served by a **Vector Database (Pinecone)**. Patient records and clinical notes are embedded and indexed so that a doctor's natural-language question ("Has this patient had a cardiac event before?") can be semantically matched to relevant chunks of patient history via a RAG (Retrieval-Augmented Generation) pipeline backed by an LLM.

**Goal 3 — Generate monthly reports** is served by **ClickHouse**, a columnar OLAP database. Bed occupancy counts, department-wise cost aggregations, and admission trends are pre-computed and stored in ClickHouse. Its columnar format enables sub-second scans over millions of rows, making it ideal for the aggregation-heavy queries that power management dashboards and PDF reports.

**Goal 4 — Stream and store real-time vitals** is served by **Apache Kafka** (event streaming) and **InfluxDB** (persistence). Kafka ingests the continuous device stream from ICU monitors, decoupling the source devices from all downstream consumers. A Kafka Streams processor filters the stream to trigger alerts on threshold breaches. InfluxDB then persists the vitals for long-term storage and ML feature extraction.

---

## OLTP vs OLAP Boundary

The transactional system ends at **PostgreSQL and InfluxDB**. These handle all write-intensive, row-level operations — inserting new patient records, updating treatment entries, and logging incoming vitals. Each write is a discrete clinical event that must be immediately consistent and durable (ACID guarantees).

The analytical system begins at **ClickHouse**. An ETL pipeline (Apache Spark or Airflow) runs nightly, pulling from PostgreSQL and transforming denormalised event data into fact and dimension tables in ClickHouse. From this point on, all data is read-only and optimised for aggregation rather than point lookups. The boundary is therefore the **ETL job itself** — it is the handoff point between the operational world (individual patient events) and the analytical world (population-level metrics across departments and time periods).

This separation ensures that long-running report queries on ClickHouse never contend with latency-sensitive write transactions on PostgreSQL.

---

## Trade-offs

**Trade-off: System complexity vs. simplicity.**

The design uses five distinct storage technologies. While each is the right tool for its use case, this introduces significant operational overhead — five different query languages, backup strategies, scaling configurations, and failure modes for the engineering team to manage. A simpler alternative would be to use PostgreSQL alone with TimescaleDB (for time-series) and pgvector (for embeddings), reducing the stack to a single engine family.

**Mitigation:** The hospital should adopt a managed cloud data platform (e.g. AWS or Azure) where Kafka, ClickHouse, and InfluxDB are available as fully managed services with built-in monitoring, auto-scaling, and backups. This transfers most of the operational burden to the cloud provider. Additionally, the team should be onboarded with infrastructure-as-code (Terraform) so the entire stack can be reproduced and audited consistently. In a resource-constrained environment, the Vector DB and InfluxDB could be deferred to Phase 2, with PostgreSQL + pgvector covering Goals 1 and 2 initially.
