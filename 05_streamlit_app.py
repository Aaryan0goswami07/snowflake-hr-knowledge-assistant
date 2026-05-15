# ============================================================
# STREAMLIT IN SNOWFLAKE — HR Knowledge Assistant Frontend
# Deploy this inside Snowflake: Projects → Streamlit → + New
# Connects Cortex Search (RAG) + Cortex Analyst (Text-to-SQL)
# ============================================================

import streamlit as st
from snowflake.snowpark.context import get_active_session
import json
import pandas as pd

# Get active Snowflake session (automatic inside Snowflake)
session = get_active_session()

# ---- PAGE CONFIG ----
st.set_page_config(page_title="HR Knowledge Assistant", layout="wide")

st.title("🏢 HR Knowledge Assistant")
st.markdown("Ask questions about **HR policies** or **employee data** in plain English.")

# ---- SIDEBAR ----
st.sidebar.title("What can I help with?")
mode = st.sidebar.radio(
    "Choose query type:",
    ["📄 HR Policies (RAG)", "📊 Employee Data (Text-to-SQL)"]
)

st.sidebar.markdown("---")
st.sidebar.markdown("**Example policy questions:**")
st.sidebar.markdown("- How many annual leave days do I get?")
st.sidebar.markdown("- What is the WFH policy?")
st.sidebar.markdown("- What happens with poor performance?")

st.sidebar.markdown("**Example data questions:**")
st.sidebar.markdown("- Who are the top earners?")
st.sidebar.markdown("- Which department takes most leave?")
st.sidebar.markdown("- Show Excellent performers")

# ---- MAIN INTERFACE ----
question = st.text_input(
    "Ask your question:",
    placeholder="e.g. How many sick leave days am I entitled to?"
)

if st.button("Ask", type="primary") and question:

    if "Policies" in mode:
        # RAG MODE — search HR policy documents
        st.subheader("📄 Answer from HR Policy Documents")

        with st.spinner("Searching HR policies..."):
            search_query = json.dumps({
                "query": question,
                "columns": ["policy_name", "section", "content"],
                "limit": 3
            })

            result = session.sql(f"""
                SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
                    'HR_ASSISTANT_DB.SEARCH.hr_policy_search',
                    '{search_query}'
                ) AS result
            """).collect()

            raw = json.loads(result[0]['RESULT'])
            results = raw.get('results', [])

        if results:
            for i, r in enumerate(results, 1):
                with st.expander(f"Source {i}: {r.get('policy_name')} — {r.get('section')}", expanded=(i==1)):
                    st.write(r.get('content'))

            # Use COMPLETE to synthesise a final answer
            context = " ".join([r.get('content','') for r in results])
            answer = session.sql(f"""
                SELECT SNOWFLAKE.CORTEX.COMPLETE(
                    'mistral-large',
                    'Based on this HR policy context, answer the question clearly and concisely in 2-3 sentences. Context: {context[:800]} Question: {question}'
                ) AS answer
            """).collect()[0]['ANSWER']

            st.success("**AI Summary:**")
            st.write(answer)
        else:
            st.warning("No relevant policy found. Try rephrasing your question.")

    else:
        # TEXT-TO-SQL MODE — query structured employee data
        st.subheader("📊 Answer from Employee Database")

        with st.spinner("Generating SQL and querying data..."):
            # Generate SQL using COMPLETE
            sql_prompt = f"""
                You are a SQL expert. Write a single Snowflake SQL query to answer this question
                about the HR database. Tables available:
                - employees(employee_id, name, department, role, salary, join_date, city, performance)
                - leave_records(leave_id, employee_id, leave_type, start_date, end_date, days_taken, approved)
                Return ONLY the SQL query, no explanation, no markdown backticks.
                Question: {question}
                Use: USE DATABASE HR_ASSISTANT_DB; USE SCHEMA RAW;
            """

            generated_sql = session.sql(f"""
                SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-large', '{sql_prompt.replace("'", "''")}') AS sql_query
            """).collect()[0]['SQL_QUERY'].strip()

            st.code(generated_sql, language='sql')

            try:
                df = session.sql(generated_sql).to_pandas()
                st.dataframe(df, use_container_width=True)

                if len(df) > 0 and df.select_dtypes(include='number').shape[1] > 0:
                    numeric_col = df.select_dtypes(include='number').columns[0]
                    if len(df) <= 10:
                        st.bar_chart(df.set_index(df.columns[0])[numeric_col])
            except Exception as e:
                st.error(f"Query error: {e}")
                st.info("Try rephrasing your question.")

# ---- FOOTER ----
st.markdown("---")
st.caption("Built with Snowflake Cortex Search + Cortex Analyst | By Aaryan Goswami")
