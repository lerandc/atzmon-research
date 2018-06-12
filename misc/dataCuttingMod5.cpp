#include <string>
#include <vector>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>

using namespace std;

struct dataInput {
  double depthNm, loaduN, times, depthV, loadV;
};

string stringConv(int);

int to_int(string);

int main(){
  string reName = "Y";
  int flip = 0;
  int testNumber, runs, currentTest;
  double cutLimit, depthNm, loaduN, times, depthV, loadV;
  string waste, holder, testNumStr, outputName, fileName, tNum, pIDans, pID, sampleID,
         outputID, dasho = "00", txt = ".txt", csv = ".csv";

  while(reName == "Y" || reName == "y"){
    reName = "N";

    cout << "Enter sample identifier (everything before numbers, include whitespace): ";
    if(flip == 1) cin.ignore(1000, '\n');
    getline(cin, sampleID);

    cout << "Is there any identifier after the numbers? (Y/N): ";
    getline(cin, pIDans);

    if(pIDans == "Y" || pIDans == "y"){
      cout << "What is the identifier after the numbers? (include leading whitespace): ";
      getline(cin, pID);
    }

    cout << "Enter desired output identifier: ";
    getline(cin, outputID);

    cout << "Enter the limit at which you want your data cut (uN): ";
    cin >> cutLimit;

    cout << "Enter starting test number (two digits): ";
    cin.ignore(1000, '\n');
    getline(cin, tNum);

    testNumber = to_int(tNum);

    cout << "Enter number of tests (include first test): ";
    cin >> runs;
    while(runs <= 0){
      cout << "Please enter a valid number of tests: ";
      cin >> runs;
    }

    int t = 0;
    while(t < runs && (reName != "Y")){ //begin system loop

      currentTest = testNumber + t;

      if(currentTest < 10) testNumStr = "0" + stringConv(currentTest);
      else testNumStr = stringConv(currentTest);

      fileName = sampleID + dasho + testNumStr;

      if(pIDans == "Y" || pIDans == "y") fileName = fileName + pID + txt;
      else fileName = fileName + txt;

      outputName = outputID + dasho + testNumStr + csv;

      ifstream textFile(fileName.c_str());

      if(textFile.fail()){
        cout << "Input file " << "\"" << fileName << "\"" << " could not be opened." << endl;
        textFile.close();

        cout << "Would you like to reenter the identifiers? (Y/N): ";
        cin.ignore(1000, '\n');
        getline(cin, holder);

        if(holder == "Y" || holder == "y"){
          reName = "Y";
          flip = 0;
        }
        else{
        cout << "Exiting program." << endl;
        return 0;
        }
      }
      else{
        for(int r = 0; r < 4; r++) getline(textFile, waste);

        vector <dataInput> data;

        int size = 0;

        textFile >> depthNm >> loaduN >> times >> depthV >> loadV;

        while(!textFile.fail()){
          size++;
          data.resize(size);
          data[size-1].depthNm = depthNm;
          data[size-1].loaduN = loaduN;
          data[size-1].times = times;
          data[size-1].depthV = depthV;
          data[size-1].loadV = loadV;
          textFile >> depthNm >> loaduN >> times >> depthV >> loadV;
        }
        textFile.close();

        ofstream csv(outputName.c_str());

        int i = 0;
        while(data[i].loaduN < cutLimit) i++;

        int k = i;

        i = i + 57000;
        while(data[i+1].loaduN > cutLimit - 5.0) i++;

        int L = 0;

        if(i%5 != 4) i = i-i%5-1;

        while(k+L <= i){
          csv << setprecision(15) << (data[k+L].times - data[k].times);
          csv << ",";
          csv << setprecision(15) << ((data[k+L].depthNm - data[k].depthNm)/data[k].depthNm);
          csv << endl;
          L++;
        }

        csv.close();
        cout << "Test " + dasho + testNumStr + " completed." << endl;
        t++;
      }


    }//end system loop

    if(reName != "Y"){
      cout << "Would you like to run another batch? (Y/N): ";
      cin.ignore(1000, '\n');
      getline(cin, reName);
    }
  }

  cout << "Exiting program." << endl;
  return 0;
}

string stringConv(int val){
  ostringstream convert;
  string s;

  convert << val;
  s = convert.str();

  return s;
};

int to_int(string str){
  istringstream change(str);
  int c;

  if ( !(change >> c) ) c = 0;

  return c;
};
