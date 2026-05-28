from sqlalchemy import create_engine

server = "localhost"
database = "aml_data"

connection_string = (
    f"mssql+pyodbc://@{server}/{database}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)

engine = create_engine(connection_string)

with engine.connect() as conn:
    print("Connected successfully!")