-- ============================================================
-- PROJECT 3: HR Knowledge Assistant
-- Snowflake Cortex Search (RAG) + Cortex Analyst (Text-to-SQL)
-- + Streamlit Frontend
-- By Aaryan Goswami
-- Concepts: RAG, embeddings, Cortex Search, Cortex Analyst,
--           hybrid search, Text-to-SQL, Streamlit in Snowflake
-- ============================================================

CREATE WAREHOUSE IF NOT EXISTS RAG_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE;

USE WAREHOUSE RAG_WH;

CREATE DATABASE IF NOT EXISTS HR_ASSISTANT_DB;
USE DATABASE HR_ASSISTANT_DB;

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS SEARCH;

USE SCHEMA RAW;

-- Structured data — for Cortex Analyst (Text-to-SQL)
CREATE OR REPLACE TABLE employees (
    employee_id     INT PRIMARY KEY,
    name            VARCHAR(100),
    department      VARCHAR(50),
    role            VARCHAR(100),
    salary          DECIMAL(10,2),
    join_date       DATE,
    city            VARCHAR(50),
    performance     VARCHAR(20)  -- 'Excellent','Good','Average','Poor'
);

CREATE OR REPLACE TABLE leave_records (
    leave_id        INT PRIMARY KEY,
    employee_id     INT REFERENCES employees(employee_id),
    leave_type      VARCHAR(50),  -- 'Sick','Casual','Annual'
    start_date      DATE,
    end_date        DATE,
    days_taken      INT,
    approved        BOOLEAN
);

-- Unstructured data — for Cortex Search (RAG)
-- HR policy documents stored as text chunks
CREATE OR REPLACE TABLE hr_policy_docs (
    doc_id          INT PRIMARY KEY,
    policy_name     VARCHAR(100),
    section         VARCHAR(100),
    content         TEXT
);
