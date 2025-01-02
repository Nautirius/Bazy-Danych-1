#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libpq-fe.h>

void execute_query_to_json(PGconn *conn, const char *query) {
    PGresult *result = PQexec(conn, query);

    if (PQresultStatus(result) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Query failed: %s\n", PQerrorMessage(conn));
        PQclear(result);
        return;
    }

    int nrows = PQntuples(result);
    int nfields = PQnfields(result);

    printf("[");
    for (int r = 0; r < nrows; r++) {
        printf("{");
        for (int f = 0; f < nfields; f++) {
            Oid field_type = PQftype(result, f);
            const char *field_name = PQfname(result, f);
            const char *field_value = PQgetvalue(result, r, f);

            printf("\"%s\":", field_name);

            switch (field_type) {
                case 23: // INT4
                case 21: // INT2
                case 20: // INT8
                    printf("%d", atoi(field_value));
                    break;
                case 700: // FLOAT4
                case 701: // FLOAT8
                case 1700: // NUMERIC
                    printf("%.4f", atof(field_value));
                    break;
                case 1043: // VARCHAR
                case 25:  // TEXT
                case 1042: // BPCHAR
                case 18: // CHAR
                    printf("\"%s\"", field_value);
                    break;
                default:
                    printf("\"%s\"", field_value); // Default to string
            }

            if (f < nfields - 1) {
                printf(",");
            }
        }
        printf("}");
        if (r < nrows - 1) {
            printf(",\n");
        }
    }
    printf("]\n");

    PQclear(result);
}

int main() {
    const char *conninfo = "host=pleadingly-credible-owl.data-1.euc1.tembo.io port=5432 dbname=postgres user=postgres password=mPGUWC9zbxjWGNOK";
    PGconn *conn = PQconnectdb(conninfo);

    if (PQstatus(conn) == CONNECTION_BAD) {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        return EXIT_FAILURE;
    }

    printf("Connected to database successfully.\n");

    // Przykład 1: Zapytanie SELECT z WHERE
    const char *query1 = "SELECT * FROM lab03.wykladowca WHERE wykladowca_id < 4;";
    printf("Wynik dla zapytania 1:\n");
    execute_query_to_json(conn, query1);

    // Przykład 2: Zapytanie SELECT ze złączeniem
    const char *query2 = "SELECT w.nazwisko, i.lokal, CAST(0.5 AS NUMERIC(10,4)) AS test_float FROM lab03.instytut i JOIN lab03.wykladowca w ON i.instytut_id=w.wykladowca_id";
    printf("\nWynik dla zapytania 2:\n");
    execute_query_to_json(conn, query2);

    PQfinish(conn);
    return EXIT_SUCCESS;
}
