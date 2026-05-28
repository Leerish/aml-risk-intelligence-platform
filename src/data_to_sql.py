from sqlalchemy import create_engine

server = "localhost"
database = "aml_data"

connection_string = (
    f"mssql+pyodbc://@{server}/{database}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)

engine = create_engine(connection_string)


customer_profile.to_sql(
    "CustomerRisk",
    engine,
    if_exists="replace",
    index=False
)




alert_queue.to_sql(
    "AlertQueue",
    engine,
    if_exists="replace",
    index=False
)


transaction_summary.to_sql(
    "TransactionSummary",
    engine,
    if_exists="replace",
    index=False
)


high_risk_transactions_sql.to_sql(
    name="HighRiskTransactions",
    con=engine,
    if_exists="append",
    index=False
)

print("Inserted:", len(high_risk_transactions_sql))


daily_metrics.to_sql(
    name="DailyTransactionMetrics",
    con=engine,
    if_exists="append",
    index=False
)