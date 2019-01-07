// Using Code from Author: Jeremy Morgan

#include <vector>
#include <string>
#include <iostream>
#include <pthread.h>
#include <chrono>
#include <thread>
#include <time.h>
#include "../include/ProjectTest.h"
#include "../include/Tests.h"

using std::vector;
using std::string;
using std::cout;
using std::clock;
using std::endl;
using std::to_string;

#define RED   "\e[38;5;196m"
#define GRN   "\e[38;5;082m"
#define YEL   "\e[38;5;226m"
#define MAG   "\e[38;5;201m"
#define RESET "\e[0m"

// Defining Global Variables
int green = 0;
int red = 0;
int tests;
const long MILLIS_TO_WAIT = 1800000;
vector<pointerToTestsFunctions> testsFunctions;
pointerToTestsFunctions currentTestFunction = 0;
string currentTestName = "NO_TEST_HAS_BEEN_SUCCESSFULLY_EXECUTED_YET";
vector<vector<string>> errorLog;
bool testFunctionActive = 0;

int main()
{
    // Starting tests
    start();

    // Initializing tests to be executed
    InitializingTests();

    // Initializing before execution of tests
    Initialize();

    // Executing tests
    ExecuteTests();

    // Finialize after execution of tests
    Finialize();
    
    // Summarizing tests
    summery();
}

// Declaring start of test
void start()
{
    // Declaring start of test
    cout << MAG << "*******************************************" << endl;
    cout << "       Start Of Final Project Test                  " << endl;
    cout << "*******************************************\n" << RESET << endl;

}

// Executing tests
void ExecuteTests()
{
    // Initializing
    int rc;

    // Executing tests
    for(unsigned int i = 0;i < testsFunctions.size();i++)
    {
      // Executing Thread
      pthread_t thread;
      currentTestFunction = testsFunctions.at(i);
      rc = pthread_create(&thread, NULL, InitiateFunctionInThread,NULL);

      // Asserting Thread Was Successfully Executed
      if (rc)
      {
        cout << "\n\n\n----------------------------\nError:unable to create thread"
             << "\n----------------------------\n\n\n" << rc << endl;

        continue;
      }

      // Waiting For Thread To Finish  -->

      //Retrieving Current Time For Timeout
      std::this_thread::sleep_for(std::chrono::milliseconds(200));
      auto t_start = std::chrono::high_resolution_clock::now();

      // Waiting For Current Test To Finish Unless Timeout
      while (testFunctionActive == 1)
      {
        // Retrieving Current Time For Timeout
        auto t_end = std::chrono::high_resolution_clock::now();

        // Calculating Current Test Duration
        float duration = std::chrono::duration<double, std::milli>(t_end-t_start).count();

        // Asserting Test Duration Did Not Pass Limit
        if(duration > MILLIS_TO_WAIT)
        {
          // Canceling Thread
          pthread_cancel(thread);

          // Declaring Test Execution Ended With TImeout
          test(-1,"$$$ TEST EXECUTION TIMED OUT $$$","");

          // Declaring test terminated
          testFunctionActive = 0;
        }
      }
    }
      // Waiting For Thread To Finish  <--
}

void * InitiateFunctionInThread(void * pVoid)
{
    // Declaring Test Thread Active
    testFunctionActive = 1;

    // Executing Test Function
    try
    {
      currentTestFunction();
    }
    catch(...)
    {
      // Declaring Exception Raised Durning Test Execution
      test(-1,"","$$$ DECLARE BAD TEST $$$");
    }

    // Declaring Test Thread No Longer Active
    testFunctionActive = 0;

    // Exiting Thread
    pthread_exit(NULL);
}

void summery()
{
    // Declaring end of test
    cout << MAG << "\n*******************************************" << endl;
    cout << "       End Of Final Project Test                    " << endl;
    cout << "*******************************************" << RESET << endl;

    // Summarizing
    cout << GRN << "Green: " <<  green << RESET <<  "," << RED << " Red: " << red << RESET << endl;

    // Printing exceptions log
    if(errorLog.size() != 0)
    {
        cout << "\nExceptions Log:\n-------------------------------------------" << endl;


        for (unsigned int i = 0;i < errorLog.size();i++)
          cout << "\n" <<  errorLog[i][0] << " exceptions log:\n" << errorLog[i][1];
    }
}

// Checking if test operated according to plan
void test(int testId,string got, string expected,vector<string> args)
{
    // Initializing
    bool testPassed = false;

    // Counting test
    tests++;

    // Calculating test results
    if(expected == "$$$ ASSERT_THROWN_EXCEPTIONS $$$")
    {
      testPassed = false;
      got = "$$$ NO EXCEPTION WAS THROWN $$$";
    }
    else if(expected == "$$$ ASSERT_NO_THROWN_EXCEPTIONS $$$" || expected == "$$$ DECLARE GOOD TEST $$$" || got == expected)
      testPassed = true;
    else if(expected == "$$$ DECLARE BAD TEST $$$")
    {
      testPassed = false;
      got = "$$$ EXCEPTION WAS THROWN $$$";
    }
    else if(expected == "$$$ TEST EXECUTION TIMED OUT $$$")
      testPassed = false;

 // Checking if test operated according to plan
    if (testPassed == true)
    {
      // Counting good test
      green++;
    }
    else
    {
      // Counting bad test and declaring
      red++;

      // Declaring bad test
      if(got == "$$$ EXCEPTION WAS THROWN $$$")
        cout << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " did not complete successfully !!!\n" << RESET;
      else if(got == "$$$ TEST EXECUTION TIMED OUT $$$")
        cout << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " took more than " <<  MILLIS_TO_WAIT/1000 << " seconds, therefore it has been timed out.\n"
             << RESET;
      else if(args[0] == "String value with /n")
        cout << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " --> Failed" << ",\n-------------------------------\ngot\n-------------------------------\n" <<
             YEL << got << RED <<
             "\n-------------------------------\nwhile expected\n-------------------------------\n" << GRN
             << expected << RED
             "\n-------------------------------\n" << RESET;
      else
        cout << RED <<  currentTestName <<  "(Test ID: " << testId << ")" <<  " --> Failed" <<
             ", got " << YEL << got << RED << " while expected " << GRN << expected << RED << ".\n" << RESET;

    }
}

// Checking if test operated according to plan
void test(int testId,float got, float expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

void test(int testId,int got, int expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

void test(int testId,unsigned int got, unsigned int expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

// Retrieving Terminal Output :: Author: Jeremy Morgan
string GetStdoutFromCommand(string cmd)
{
  // Initializing
  string data;
  FILE * stream;
  const int max_buffer = 4000;
  char buffer[max_buffer];
  cmd.append(" 2>&1");
  stream = popen(cmd.c_str(), "r");

  // Retrieving Terminal Output
  if (stream)
  {
      while (!feof(stream))
      {
        if (fgets(buffer, max_buffer, stream) != NULL)
          data.append(buffer);
      }

      pclose(stream);
  }

  return data;
}
