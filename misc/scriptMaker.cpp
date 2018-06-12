#include <string>
#include <vector>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>

using namespace std;

void replace_name(string &line, const string &name, const string &replacement){
  int start = line.find(name);
  line.erase(start, 7);

  line.insert(start, replacement);

}

int to_int(string str){
  istringstream change(str);
  int c;

  if ( !(change >> c) ) c = 0;

  return c;
};

string stringConv(int val){
  ostringstream convert;
  string s;

  convert << val;
  s = convert.str();

  return s;
};

int main(){

string repeat = "Y", file_name, output_ampl, amplfit_file, read_line, output_job, amplfit_name;
string dasho = "00", replace = "REPLACE", testNumStr, tNum;

int runs, testNumber, currentTest;

cout << "Enter the name of the amplfit file: ";
getline(cin, amplfit_name);

while(repeat == "Y" || repeat == "y"){
  repeat = "N";

  cout << "Enter the name of the input identifier: ";
  getline(cin, file_name);

  cout << "Enter the first test number (two digits): ";
  getline(cin, tNum);
  testNumber = to_int(tNum);

  cout << "Enter the number of tests (include first test): ";
  cin >> runs;
  while(runs <= 0){
    cout << "Please enter a valid number of tests: ";
    cin >> runs;
  }

  int t = 0;
  while(t < runs){

  currentTest = testNumber + t;

  if(currentTest < 10) testNumStr = "0" + stringConv(currentTest);
  else testNumStr = stringConv(currentTest);

  output_ampl = amplfit_name + "-" + file_name + dasho + testNumStr + ".txt";
  amplfit_file = amplfit_name + ".txt";

  ifstream amplfit(amplfit_file.c_str());
  ofstream o_ampl(output_ampl.c_str());

  getline(amplfit, read_line);

  while(!amplfit.fail()){
    if(read_line.find(replace) != read_line.npos)
      replace_name(read_line, replace, (file_name + dasho + testNumStr));

    o_ampl << read_line << endl;

    getline(amplfit, read_line);
  }

  amplfit.close();
  o_ampl.close();
  t++;
  }


  cout << "Another batch? (Y/N): ";
  cin.ignore(1000, '\n');
  getline(cin, file_name);
}
return 0;
}
