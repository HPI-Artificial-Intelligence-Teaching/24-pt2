/******************************************************************************
 *
 * A brute-force implementation of the 3-sums problems.
 *
 * Based on the source code from Robert Sedgewick and Kevin Wayne at https://algs4.cs.princeton.edu/
 *
 *  A program with cubic running time. Read in N integers and counts the number of triples that sum to exactly 0
 *  (ignoring integer overflow).
 *
 *  ./3sums_fast < ../data/8ints.txt 
 *  4
 * 
 *  ./3sums_fast < ../data/1Kints.txt 
 *  70
 *
 *  ./3sums_fast < ../data/2Kints.txt 
 *  528
 *
 *  ./3sums_fast < ../data/4Kints.txt 
 *  4039
 * 
 *  ./3sums_fast < ../data/8Kints.txt 
 *  32074
 * 
 *  ./3sums_fast < ../data/16Kints.txt 
 *  255181
 * 
 *  ./3sums_fast < ../data/32Kints.txt 
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

// insertion sort algorithm to sort the list
void insertion_sort(int* list, const int size) {
    for (auto i = 1; i < size; i++) {
        for (auto j = i; j > 0 && list[j] < list[j - 1]; j--) {
            // swap list[j] and list[j - 1]
            int temp = list[j];
            list[j] = list[j - 1];
            list[j - 1] = temp;
        }
    }
    return;
}

// binary search algorithm to find the key in the list
int binary_search(const int* list, const int size, const int key) {
    int lo = 0;
    int hi = size - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (key < list[mid]) {
            hi = mid - 1;
        } else if (key > list[mid]) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}

// counts the number of triples that sum to exactly 0
int count_3sums(int* list, const int size) {
    // first sort the list 
    insertion_sort(list, size);

    // now only do a double-loop and find the missing element using binary search
    int count = 0;
    for (auto i = 0; i < size; i++) {
        for (auto j = i + 1; j < size; j++) {
            int k = binary_search(list, size, -(list[i] + list[j]));
            if (k > j) {
                count++;
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
