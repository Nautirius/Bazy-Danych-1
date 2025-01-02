#include <stdlib.h>
#include <stdio.h>
#include <libpq-fe.h>
int main()
{
  PGconn *conn;
  const char *connection_str = "host=pleadingly-credible-owl.data-1.euc1.tembo.io port=5432 dbname=postgres user=postgres password=mPGUWC9zbxjWGNOK";
  conn = PQconnectdb(connection_str);
  if (PQstatus(conn) == CONNECTION_BAD) {
     fprintf(stderr, "Connection to %s failed, %s",connection_str,PQerrorMessage(conn));
  } else {
     printf("Connected OK\n");
     printf("PGDBNAME = %s\n",PQdb(conn));
     printf("PGUSER = %s\n",PQuser(conn));
     printf("PGPASSWORD = %s\n",PQpass(conn));
     printf("PGHOST = %s\n",PQhost(conn));
     printf("PGPORT = %s\n",PQport(conn));
     printf("OPTIONS = %s\n",PQoptions(conn));
  }
  PQfinish(conn);
  return EXIT_SUCCESS;
}