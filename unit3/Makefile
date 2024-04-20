TARGETS = 3sums 3sums_fast
CXX = g++
CPPFLAGS = -std=c++17 -O3
LDLIBS=-lm

all: $(TARGETS)

3sums: 3sums.cpp 
	$(CXX) $(CPPFLAGS) -o $@ $<

3sums_fast: 3sums_fast.cpp 
	$(CXX) $(CPPFLAGS) -o $@ $<

clean:
	$(RM) $(TARGETS)

.PHONY: all clean