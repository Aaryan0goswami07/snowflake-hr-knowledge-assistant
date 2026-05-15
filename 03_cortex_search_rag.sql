-- ============================================================
-- CORTEX SEARCH — RAG on HR Policy Documents
-- This is the "talk to unstructured data" part of Course 3
-- ============================================================

USE DATABASE HR_ASSISTANT_DB;
USE WAREHOUSE RAG_WH;

-- STEP 1: Create a Cortex Search Service
-- This automatically chunks, embeds, and indexes your documents
-- Think of it as building a smart search engine on your text
CREATE OR REPLACE CORTEX SEARCH SERVICE HR_ASSISTANT_DB.SEARCH.hr_policy_search
  ON content
  ATTRIBUTES policy_name, section
  WAREHOUSE = RAG_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT
        doc_id,
        policy_name,
        section,
        content
    FROM HR_ASSISTANT_DB.RAW.hr_policy_docs
  );


-- STEP 2: Query the search service using natural language
-- This is RAG in action — embedding your question,
-- finding the most relevant chunks, returning grounded answers

-- Question 1: How many annual leave days do I get?
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'HR_ASSISTANT_DB.SEARCH.hr_policy_search',
    '{
        "query": "How many annual leave days am I entitled to?",
        "columns": ["policy_name", "section", "content"],
        "limit": 2
    }'
) AS rag_result;


-- Question 2: What happens if I get a poor performance rating?
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'HR_ASSISTANT_DB.SEARCH.hr_policy_search',
    '{
        "query": "What happens to employees with poor performance rating?",
        "columns": ["policy_name", "section", "content"],
        "limit": 2
    }'
) AS rag_result;


-- Question 3: Can I work from home?
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'HR_ASSISTANT_DB.SEARCH.hr_policy_search',
    '{
        "query": "What is the work from home policy?",
        "columns": ["policy_name", "section", "content"],
        "limit": 2
    }'
) AS rag_result;


-- STEP 3: Hybrid search — combine keyword + semantic search
-- Hybrid search is more accurate than either alone
-- Use filter to narrow by policy category
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'HR_ASSISTANT_DB.SEARCH.hr_policy_search',
    '{
        "query": "bonus and salary increment",
        "columns": ["policy_name", "section", "content"],
        "filter": {"@eq": {"policy_name": "Performance Policy"}},
        "limit": 2
    }'
) AS hybrid_search_result;

