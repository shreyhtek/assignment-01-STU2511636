# Vector DB Reflection

## Vector DB Use Case

A traditional keyword-based search would **not** suffice for the law firm's contract search system, and the reason comes down to how meaning is represented.

Keyword search works by matching exact or stemmed words. If a lawyer asks *"What are the termination clauses?"*, a keyword engine looks for documents containing the words "termination" and "clauses". But a 500-page contract might express the same concept as *"conditions for dissolution of agreement"* or *"exit provisions"* — none of which share the exact keywords. The query returns nothing, or worse, returns irrelevant sections that happen to contain the word "termination" in a different context (e.g., "termination of warranty").

A vector database solves this by working with **semantic embeddings** — high-dimensional numerical representations of text where meaning, not spelling, determines proximity. When the lawyer types a plain-English question, a model like `all-MiniLM-L6-v2` converts both the question and every clause in the contract into vectors. Clauses that are semantically similar to the question — regardless of exact wording — will have a high cosine similarity score and appear at the top of results.

In this system, the vector database would be used as follows. At ingestion time, each page or paragraph of the contract is split into chunks, embedded using a language model, and stored in a vector database such as Pinecone, Weaviate, or ChromaDB. At query time, the lawyer's question is embedded using the same model, and the database performs an approximate nearest-neighbour search to retrieve the most semantically relevant chunks in milliseconds.

This architecture — often called **Retrieval-Augmented Generation (RAG)** — can then pass those retrieved chunks to an LLM to generate a precise, grounded answer. The result is a system that genuinely understands legal language rather than pattern-matching on keywords, making it far more reliable for high-stakes contract review.
