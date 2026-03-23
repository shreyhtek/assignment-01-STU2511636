# RDBMS vs NoSQL — Database Recommendation

## Database Recommendation

For a healthcare startup's patient management system, I would recommend **MySQL** (or another RDBMS) as the primary database — and here is why.

Patient data is among the most sensitive and legally regulated data that exists. Every record update — a prescription change, a lab result, a diagnosis — must be **atomic, consistent, isolated, and durable (ACID)**. If a doctor updates a patient's medication dosage and the system crashes mid-write, an ACID-compliant database rolls back to the last known-good state automatically. MongoDB, which follows the **BASE** model (Basically Available, Soft state, Eventually consistent), cannot offer this guarantee by default. Even with MongoDB's multi-document transactions (available since v4.0), they add significant overhead and are not its native strength.

The **CAP theorem** tells us that a distributed system can guarantee at most two of: Consistency, Availability, and Partition tolerance. MySQL prioritises **Consistency + Partition tolerance (CP)**. For healthcare, consistency is non-negotiable — a patient's record must never show stale or conflicting data depending on which server node responds. MongoDB, as a BASE system, leans toward **Availability + Partition tolerance (AP)**, accepting eventual consistency in exchange for uptime. That trade-off is appropriate for a shopping cart, not a drug prescription.

Patient records also have a well-understood, stable schema — demographics, appointments, diagnoses, prescriptions, billing — that maps naturally to relational tables with foreign keys and JOIN queries. RDBMS handles this cleanly and enforces referential integrity by design.

**Would this change for a fraud detection module?** Yes — partially. Fraud detection requires analysing large volumes of rapidly incoming, unpredictable event data (login attempts, payment patterns, device fingerprints) in real time. This is a workload where MongoDB or a purpose-built time-series / graph database (like Neo4j) would outperform a relational system due to its flexible schema and horizontal write scalability. The recommended architecture would therefore be **hybrid**: MySQL for the core patient management system, and MongoDB (or a streaming store like Apache Kafka + a document DB) as the fraud detection layer, with the two systems communicating via events rather than sharing a single database.
