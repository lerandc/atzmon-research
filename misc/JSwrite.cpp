#include <string>
#include <vector>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>

using namespace std;

int main (){

  ifstream original("JobScript.txt");
  ofstream newer("JobScriptNew.pbs");

  string read_line;

  getline(original, read_line);
  while(!original.fail()){

    newer << read_line << '\n';

    getline(original, read_line);
  }

  original.close();
  newer.close();
return 0;
}
