/******************************************************************************
 *
 * A brute-force implementation of the 3-sums problems.
 *
 * Based on the source code from Robert Sedgewick and Kevin Wayne at https://algs4.cs.princeton.edu/
 *
 *  A program with cubic running time. Read in N integers and counts the number of triples that sum to exactly 0
 *  (ignoring integer overflow).
 *
 *  ./3sums < ../data/8ints.txt 
 *  4
 * 
 *  ./3sums < ../data/1Kints.txt 
 *  70
 *
 *  ./3sums < ../data/2Kints.txt 
 *  528
 *
 *  ./3sums < ../data/4Kints.txt 
 *  4039
 * 
 *  ./3sums < ../data/8Kints.txt 
 *  32074
 * 
 *  ./3sums < ../data/16Kints.txt 
 *  255181
 * 
 *  ./3sums < ../data/32Kints.txt 
 *  2052358
 * 
 ******************************************************************************/

#include <iostream>
#include <iomanip>
#include <ctime>

#define MAX_SIZE 1000000

using namespace std;

// prints the list of integers on the screen
void print_list(const int* list, const int size) {
    for (auto i = 0; i < size; i++) {
        cout << list[i] << endl;
    }
    return;
}

// counts the number of triples that sum to exactly 0
int count_3sums(const int* list, const int size) {
    int count = 0;
    for (auto i = 0; i < size; i++) {
        for (auto j = i + 1; j < size; j++) {
            for (auto k = j + 1; k < size; k++) {
                if (list[i] + list[j] + list[k] == 0) {
                    count++;
                }
            }
        }
    }
    return count;
}

// main entry point of the program
int main(int argc, char* argv[]) {
    int a[MAX_SIZE];
    int n = 0;

    // read the list of integers from the standard input
    while (n < MAX_SIZE && (cin >> a[n])) {
        n++;
    }

    // get the initial clock count
    auto start = clock();

    // computes the number of triples that sum to exactly 0 and outputs the count on the screen
    cout << count_3sums(a, n) << endl;

    // output execution time
    cout << "Time of execution: " 
         << setprecision(4) 
         << double(clock() - start)/double(CLOCKS_PER_SEC) 
         << " seconds" << endl;

    return (0);
}
