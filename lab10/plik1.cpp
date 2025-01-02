#include <iostream>
#include <sstream>
#include <string>
#include <pqxx/pqxx>
#include "lab10.h"


using namespace std;
using namespace pqxx;

int main(int argc, char* argv[]) {

    stringstream ss;
    ss << "dbname = " << labdbname << " user = " << labdbuser << " password = " << labdbpass \
        << " host = " << labdbhost << " port = " << labdbport;
    string s = ss.str();

    try {
        connection connlab(s);
        if (connlab.is_open()) {
            cout << "Successfully connection to: " << connlab.dbname() << endl;
        } else {
            cout << "Problem with connection to database" << endl;
            return 1;
        }
        connlab.disconnect ();
    } catch (const std::exception &e) {
        cerr << e.what() << std::endl;
        return 1;
    }
}