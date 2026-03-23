# ETL Notes — Retail Transactions Data Warehouse

## ETL Decisions

### Decision 1: Standardising three mixed date formats

**Problem:** The `date` column in `retail_transactions.csv` contained dates in three different formats mixed across 300 rows — `DD/MM/YYYY` (105 rows, e.g. `29/08/2023`), `DD-MM-YYYY` (83 rows, e.g. `12-12-2023`), and `YYYY-MM-DD` ISO format (112 rows, e.g. `2023-02-05`). Storing these mixed formats as strings makes chronological sorting wrong and GROUP BY month impossible — `12-12-2023` would sort differently from `2023-12-12` even though they represent the same date.

**Resolution:** A format-detection parser was applied during ETL that tried each of the three known formats in order and converted every date to ISO `YYYY-MM-DD`. In `dim_date`, dates are stored as the native `DATE` type, and the surrogate key `date_id` uses `YYYYMMDD` integer format (e.g. `20231212`) which is both human-readable and naturally sortable without casting.

---

### Decision 2: Inferring NULL store_city values from store_name

**Problem:** 19 of the 300 rows had `NULL` in the `store_city` column. These came from stores such as `Mumbai Central`, `Delhi South`, and `Chennai Anna`. Leaving NULLs in a dimension table causes those rows to be excluded from GROUP BY city queries silently — the examiner would see incorrect city-level aggregations without any error message.

**Resolution:** Since every store has a fixed, known city embedded in its name, a lookup map was built (`"Mumbai Central" → "Mumbai"`, `"Delhi South" → "Delhi"`, etc.) and applied to fill all 19 NULL values during transformation. After cleaning, `store_city` had zero NULLs across all 300 rows. This is preferable to defaulting to `"Unknown"` because the true city was deterministically recoverable from the data.

---

### Decision 3: Normalising inconsistent category casing and naming

**Problem:** The `category` column had five distinct raw values for what should be only three categories — `'electronics'` (41 rows), `'Electronics'` (60 rows), `'Grocery'` (87 rows), `'Groceries'` (40 rows), and `'Clothing'` (72 rows). A simple `GROUP BY category` on the raw data would produce five groups instead of three, splitting the Electronics and Groceries totals incorrectly and making the Q1 revenue-by-category query produce wrong results.

**Resolution:** An explicit mapping was applied during ETL: `'electronics'` and `'Electronics'` → `'Electronics'`; `'Grocery'` and `'Groceries'` → `'Groceries'`; `'Clothing'` → `'Clothing'`. The cleaned values were validated against an approved whitelist of three categories before loading into `dim_product`. After cleaning, all 300 rows have consistent Title Case category values.
