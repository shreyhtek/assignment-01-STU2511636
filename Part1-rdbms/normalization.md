# Part 1 — Relational Databases

## Anomaly Analysis

The file `orders_flat.csv` is a denormalized spreadsheet (186 rows × 15 columns) that stores orders, customers, products, and sales representatives all in a single flat table. This structure introduces the following three anomalies.

---

### Insert Anomaly

**Definition:** A record that should logically exist cannot be inserted without fabricating unrelated data.

**Example:** A new sales representative cannot be added to the system without first creating a dummy order.

All sales rep data (`sales_rep_id`, `sales_rep_name`, `sales_rep_email`, `office_address`) is stored only inside order rows. There is no standalone rep table. If a fourth rep — say SR04 — is hired, there is no row in which to record them until they have at least one real order. The rep's existence is entirely dependent on the existence of an order row.

| Affected Columns |
|---|
| `sales_rep_id`, `sales_rep_name`, `sales_rep_email`, `office_address` |

---

### Update Anomaly

**Definition:** A single real-world fact is stored redundantly across multiple rows, so updating it in one place can leave other rows inconsistent.

**Example:** Sales rep SR01 (Deepak Joshi) has two different values for `office_address` across rows.

| Row (0-indexed) | `order_id` | `sales_rep_id` | `office_address` |
|---|---|---|---|
| Row 1 | ORD1114 | SR01 | `Mumbai HQ, Nariman Point, Mumbai - 400021` |
| Row 37 | ORD1180 | SR01 | `Mumbai HQ, Nariman Pt, Mumbai - 400021` ← inconsistent |

SR01's address was partially updated in some rows ("Nariman Pt" instead of "Nariman Point") but not corrected in all of them. Because the address is repeated in every order row belonging to SR01, a partial update leaves the data in an inconsistent state.

| Affected Columns |
|---|
| `sales_rep_id`, `office_address` |

---

### Delete Anomaly

**Definition:** Deleting a row to remove one piece of information unintentionally destroys other unrelated information.

**Example:** Deleting all orders for customer C001 (Rohan Mehta) would permanently erase all record of that customer.

Customer details (`customer_id`, `customer_name`, `customer_email`, `customer_city`) are stored only inside order rows — there is no separate customers table. C001 appears in 20 order rows. If all 20 were deleted (e.g., due to cancellations or a data purge), every fact about Rohan Mehta would be lost from the database entirely.

| Customer | Rows affected | Columns lost on deletion |
|---|---|---|
| C001 — Rohan Mehta | 20 rows (e.g., ORD1114, ORD1091, ORD1044 …) | `customer_id`, `customer_name`, `customer_email`, `customer_city` |

---
