/******************************************************************************
 *
 *  Fibonacci numbers with and without memoization
 *
 *  % ./time fib 50
 *
 ******************************************************************************/

#include <iostream>

using namespace std;

// Fibonacci numbers without memoization
long long fib(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fib(n - 1) + fib(n - 2);
}

// Fibonacci numbers with memoization
long long fib_fast(int n, long long* memo) {
    if (n == 0) return 0;
    if (n == 1) return 1;
    if (memo[n] == -1)
        memo[n] = fib_fast(n - 1, memo) + fib_fast(n - 2, memo);
    return memo[n];
}

#define N 1000

int main(int argc, char* argv[]) {

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <n>" << endl;
        return (1);
    }
    auto n = atoi(argv[1]);
    if (n >= N) {
        cerr << "n must be less than " << N << endl;
        return (1);
    }

    #ifdef FAST
        long long memo[N];

        for (auto i = 0; i < N; i++)
            memo[i] = -1;

        cout << "fib(" << n << ") = " << fib_fast(n, memo) << endl;
    #else
        cout << "fib(" << n << ") = " << fib(n) << endl;
    #endif

    return (0);
}