#ifndef TESTS_H_
#define TESTS_H_

#include <vector>
#include <complex>
#include <string>

using std::string;
using std::vector;
using std::complex;

// Declaring Functions
void InitializingTests();
void Initialize();
void Finialize();
bool procceseTest(string testFile,unsigned int testNumber);
unsigned int CreateTests();
void sigintHandler(int num);
void FINAL_PROJECT_TEST();

#endif
